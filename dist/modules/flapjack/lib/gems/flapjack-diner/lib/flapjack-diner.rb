require 'httparty'
require 'json'
require 'uri'
require 'cgi'

require "flapjack-diner/version"
require "flapjack-diner/argument_validator"

module Flapjack
  module Diner
    SUCCESS_STATUS_CODES = [200, 201, 204]

    include HTTParty

    format :json

    class << self

      attr_accessor :logger

      # NB: clients will need to handle any exceptions caused by,
      # e.g., network failures or non-parseable JSON data.

      def entities
        perform_get('/entities')
      end

      def create_entities!(params = {})
        params = [params] if params.respond_to?(:keys)
        perform_post('/entities', {'entities' => params})
      end

      def checks(entity)
        # FIXME: make work with new jsonapi endpoints
        raise "unimplemented"
        #perform_get("/checks/#{escape(entity)}")
      end

      def status(entity, options = {})
        check = options.delete(:check)
        path = check.nil? ? "/status/#{escape(entity)}" : "/status/#{escape(entity)}/#{escape(check)}"
        perform_get(path)
      end

      def bulk_status(options = {})
        validate_bulk_params(options)
        perform_get('/status', options)
      end

      # maybe rename 'create_acknowledgement!' ?
      def acknowledge!(entity, check, options = {})
        args = options.merge(:check => {entity => check})
        validate_bulk_params(args)
        perform_post('/acknowledgements', args)
      end

      def bulk_acknowledge!(options = {})
        validate_bulk_params(options)
        perform_post('/acknowledgements', options)
      end

      # maybe rename 'create_test_notifications!' ?
      def test_notifications!(entity, check, options = {})
        args = options.merge(:check => {entity => check})
        validate_bulk_params(args)
        perform_post('/test_notifications', args)
      end

      def bulk_test_notifications!(options = {})
        validate_bulk_params(options)
        perform_post('/test_notifications', options)
      end

      def create_scheduled_maintenance!(entity, check, options = {})
        args = options.merge( check ? {:check => {entity => check}} : {:entity => entity} )

        validate_bulk_params(args) do
          validate :query => :start_time, :as => [:required, :time]
          validate :query => :duration, :as => [:required, :integer]
        end

        perform_post('/scheduled_maintenances', args)
      end

      def bulk_create_scheduled_maintenance!(options = {})
        validate_bulk_params(options) do
          validate :query => :start_time, :as => [:required, :time]
          validate :query => :duration, :as => [:required, :integer]
        end

        perform_post('/scheduled_maintenances', options)
      end

      def delete_scheduled_maintenance!(entity, check, options = {})
        args = options.merge( check ? {:check => {entity => check}} : {:entity => entity} )

        validate_bulk_params(args) do
          validate :query => :start_time, :as => :required
        end

        perform_delete('/scheduled_maintenances', args)
      end

      def bulk_delete_scheduled_maintenance!(options = {})
        validate_bulk_params(options) do
          validate :query => :start_time, :as => :required
        end

        perform_delete('/scheduled_maintenances', options)
      end

      def delete_unscheduled_maintenance!(entity, check, options = {})
        args = options.merge( check ? {:check => {entity => check}} : {:entity => entity} )
        validate_bulk_params(args) do
          validate :query => :end_time, :as => :time
        end
        perform_delete('/unscheduled_maintenances', args)
      end

      def bulk_delete_unscheduled_maintenance!(options)
        validate_bulk_params(options) do
          validate :query => :end_time, :as => :time
        end
        perform_delete('/unscheduled_maintenances', options)
      end

      def scheduled_maintenances(entity, options = {})
        check = options.delete(:check)

        validate_params(options) do
          validate :query => [:start_time, :end_time], :as => :time
        end

        ec_path = entity_check_path(entity, check)
        perform_get("/scheduled_maintenances/#{ec_path}", options)
      end

      def bulk_scheduled_maintenances(options = {})
        validate_bulk_params(options) do
          validate :query => [:start_time, :end_time], :as => :time
        end

        perform_get('/scheduled_maintenances', options)
      end

      def unscheduled_maintenances(entity, options = {})
        check = options.delete(:check)

        validate_params(options) do
          validate :query => [:start_time, :end_time], :as => :time
        end

        ec_path = entity_check_path(entity, check)
        perform_get("/unscheduled_maintenances/#{ec_path}", options)
      end

      def bulk_unscheduled_maintenances(options = {})
        validate_bulk_params(options) do
          validate :query => [:start_time, :end_time], :as => :time
        end

        perform_get('/unscheduled_maintenances', options)
      end

      def outages(entity, options = {})
        check = options.delete(:check)

        validate_params(options) do
          validate :query => [:start_time, :end_time], :as => :time
        end

        ec_path = entity_check_path(entity, check)
        perform_get("/outages/#{ec_path}", options)
      end

      def bulk_outages(options = {})
        validate_bulk_params(options) do
          validate :query => [:start_time, :end_time], :as => :time
        end

        perform_get('/outages', options)
      end

      def downtime(entity, options = {})
        check = options.delete(:check)

        validate_params(options) do
          validate :query => [:start_time, :end_time], :as => :time
        end

        ec_path = entity_check_path(entity, check)

        perform_get("/downtime/#{ec_path}", options)
      end

      def bulk_downtime(options = {})
        validate_bulk_params(options) do
          validate :query => [:start_time, :end_time], :as => :time
        end

        perform_get('/downtime', options)
      end

      def entity_tags(entity)
        # FIXME: make work with new jsonapi endpoints
        raise "unimplemented"
        #perform_get("/entities/#{escape(entity)}/tags")
      end

      def add_entity_tags!(entity, *tags)
        # FIXME: make work with new jsonapi endpoints
        raise "unimplemented"
        #perform_post("/entities/#{escape(entity)}/tags", :tag => tags)
      end

      def delete_entity_tags!(entity, *tags)
        perform_delete("/entities/#{escape(entity)}/tags", :tag => tags)
      end

      def contacts(contact_ids = nil)
        location = '/contacts'
        if contact_ids
          contact_ids = [contact_ids] unless contact_ids.respond_to?(:each)
          location += '/' + contact_ids.map {|c| escape(c)}.join(',')
        end
        perform_get(location)
      end

      def contact(contact_id)
        #perform_get("/contacts/#{escape(contact_id)}")
        contacts([contact_id])
      end

      def create_contacts!(params = {})
        params = [params] if params.respond_to?(:keys)
        perform_post('/contacts', {'contacts' => params})
      end

      def update_contact!(contact_id, contact)
        perform_put("/contacts/#{escape(contact_id)}", contact)
      end

      def delete_contact!(contact_id)
        perform_delete("/contacts/#{escape(contact_id)}")
      end

      # PATCH /contacts/a346e5f8-8260-43bd-820b-fcb91ba6c940
      # [{"op":"add","path":"/contacts/0/links/entities/-","value":"foo-app-01.example.com"}]
      def add_entities_to_contact!(contact_id, entities)
        entities = [entities] if entities.respond_to?(:keys)
        entities.each do |entity_id|
          perform_patch("/contacts/#{escape(contact_id)}",
                        [{:op    => 'add',
                          :path  => '/contacts/0/links/entities/-',
                          :value => entity_id}])
        end
      end

      def get_entities_for_contacts(contact_ids)
        contact_ids = [contact_ids] unless contact_ids.respond_to?(:each)
        result = perform_get('/contacts/' + contact_ids.map {|c| escape(c)}.join(','))
        result['linked']['entities']
      end

      def contact_tags(contact_id)
        # FIXME: make work with new jsonapi endpoints
        raise "unimplemented"
        #perform_get("/contacts/#{escape(contact_id)}/tags")
      end

      def contact_entitytags(contact_id)
        # FIXME: make work with new jsonapi endpoints
        raise "unimplemented"
        #perform_get("/contacts/#{escape(contact_id)}/entity_tags")
      end

      def add_contact_tags!(contact_id, *tags)
        # FIXME: make work with new jsonapi endpoints
        raise "unimplemented"
        #perform_post("/contacts/#{escape(contact_id)}/tags", :tag => tags)
      end

      # TODO better checking of provided data
      def add_contact_entitytags!(contact_id, entity_tags = {})
        # FIXME: make work with new jsonapi endpoints
        raise "unimplemented"
        #perform_post("/contacts/#{escape(contact_id)}/entity_tags", :entity => entity_tags)
      end

      def delete_contact_tags!(contact_id, *tags)
        # FIXME: make work with new jsonapi endpoints
        raise "unimplemented"
        #perform_delete("/contacts/#{escape(contact_id)}/tags", :tag => tags)
      end

      # TODO better checking of provided data
      def delete_contact_entitytags!(contact_id, entity_tags = {})
        # FIXME: make work with new jsonapi endpoints
        raise "unimplemented"
        #perform_delete("/contacts/#{escape(contact_id)}/entity_tags", :entity => entity_tags)
      end

      def notification_rules(contact_id)
        # FIXME: use GET /contacts/:id (and possibly GET /notification_rules/:id if needs be, but
        # should be in linked hash)
        raise "unimplemented"
        #perform_get("/contacts/#{escape(contact_id)}/notification_rules")
      end

      def notification_rule(rule_id)
        perform_get("/notification_rules/#{escape(rule_id)}")
      end

      def create_notification_rule!(rules)
        rules = [rules] if rules.respond_to?(:keys)
        perform_post('/notification_rules', {'notification_rules' => rules})
      end

      def update_notification_rule!(rule_id, rule)
        perform_put("/notification_rules/#{escape(rule_id)}", {'notification_rules' => [rule]})
      end

      def delete_notification_rule!(rule_id)
        perform_delete("/notification_rules/#{escape(rule_id)}")
      end

      def create_media!(media)
        media = [media] if media.respond_to?(:keys)
        perform_post('/media', {'media' => media})
      end

      def contact_media(contact_id)
        # FIXME: make work with new jsonapi endpoints
        #raise "unimplemented"
        perform_get("/contacts/#{escape(contact_id)}/media")
      end

      def contact_medium(contact_id, media_type)
        # FIXME: make work with new jsonapi endpoints
        raise "unimplemented"
        #perform_get("/contacts/#{escape(contact_id)}/media/#{escape(media_type)}")
      end

      def update_contact_medium!(contact_id, media_type, media)
        # FIXME: make work with new jsonapi endpoints
        raise "unimplemented"
        #perform_put("/contacts/#{escape(contact_id)}/media/#{escape(media_type)}", media)
      end

      def delete_contact_medium!(contact_id, media_type)
        # FIXME: make work with new jsonapi endpoints
        raise "unimplemented"
        #perform_delete("/contacts/#{escape(contact_id)}/media/#{escape(media_type)}")
      end

      def contact_timezone(contact_id)
        # FIXME: make work with new jsonapi endpoints (or remove?)
        raise "unimplemented"
        #perform_get("/contacts/#{escape(contact_id)}/timezone")
      end

      def update_contact_timezone!(contact_id, timezone)
        # FIXME: make work with new jsonapi endpoints (or remove?)
        raise "unimplemented"
        #perform_put("/contacts/#{escape(contact_id)}/timezone", :timezone => timezone)
      end

      def delete_contact_timezone!(contact_id)
        # FIXME: make work with new jsonapi endpoints (or remove?)
        raise "unimplemented"
        #perform_delete("/contacts/#{escape(contact_id)}/timezone")
      end

      def last_error
        @last_error
      end

      private

      def perform_get(path, params = nil)
        req_uri = build_uri(path, params)
        logger.info "GET #{req_uri}" if logger
        response = get(req_uri.request_uri)
        handle_response(response)
      end

      def perform_post(path, data = {})
        req_uri = build_uri(path)
        if logger
          log_post = "POST #{req_uri}"
          log_post << "\n  Params: #{data.inspect}" if data
          logger.info log_post
        end
        opts = data ? {:body => prepare_nested_query(data).to_json, :headers => {'Content-Type' => 'application/vnd.api+json'}} : {}
        response = post(req_uri.request_uri, opts)
        handle_response(response)
      end

      def perform_patch(path, data = {})
        req_uri = build_uri(path)
        if logger
          log_patch = "PATCH #{req_uri}"
          log_patch << "\n  Params: #{data.inspect}" if data
          logger.info log_patch
        end
        opts = data ? {:body    => prepare_nested_query(data).to_json,
                       :headers => {'Content-Type' => 'application/json-patch+json'}} : {}
        response = patch(req_uri.request_uri, opts)
        handle_response(response)
      end

      def perform_put(path, body = {})
        req_uri = build_uri(path)
        if logger
          log_put = "PUT #{req_uri}"
          log_put << "\n  Params: #{body.inspect}" if body
          logger.info log_put
        end
        opts = body ? {:body => prepare_nested_query(body).to_json, :headers => {'Content-Type' => 'application/vnd.api+json'}} : {}
        response = put(req_uri.request_uri, opts)
        handle_response(response)
      end

      def perform_delete(path, body = nil)
        req_uri = build_uri(path)
        if logger
          log_delete = "DELETE #{req_uri}"
          log_delete << "\n  Params: #{body.inspect}" if body
          logger.info log_delete
        end
        opts = body ? {:body => prepare_nested_query(body).to_json, :headers => {'Content-Type' => 'application/json'}} : {}
        response = delete(req_uri.request_uri, opts)
        handle_response(response)
      end

      def handle_response(response)
        response_body = response.body
        response_start = response_body ? response_body[0..300] : nil
        if logger
          response_message = " #{response.message}" unless (response.message.nil? || response.message == "")
          logger.info "  Response Code: #{response.code}#{response_message}"
          logger.info "  Response Body: #{response_start}" if response_start
        end
        parsed_response = response.respond_to?(:parsed_response) ? response.parsed_response : nil
        unless SUCCESS_STATUS_CODES.include?(response.code)
          self.last_error = {'status_code' => response.code}.merge(parsed_response)
          return nil
        end
        return true unless (response.code == 200) && parsed_response
        parsed_response
      end

      def validate_bulk_params(query = {}, &validation)
        errors = []

        entities = query[:entity]
        checks   = query[:check]

        if entities && !entities.is_a?(String) &&
           (!entities.is_a?(Array) || !entities.all? {|e| e.is_a?(String)})
          raise ArgumentError.new("Entity argument must be a String, or an Array of Strings")
        end

        if checks && (!checks.is_a?(Hash) || !checks.all? {|k, v|
          k.is_a?(String) && (v.is_a?(String) || (v.is_a?(Array) && v.all?{|vv| vv.is_a?(String)}))
        })
          raise ArgumentError.new("Check argument must be a Hash with keys String, values either String or Array of Strings")
        end

        if entities.nil? && checks.nil?
          raise ArgumentError.new("Entity and/or check arguments must be provided")
        end

        validate_params(query, &validation)
      end

      def validate_params(query = {}, &validation)
        ArgumentValidator.new(query).instance_eval(&validation) if block_given?
      end

      def entity_check_path(entity, check)
        check.nil? ? "#{escape(entity)}" : "#{escape(entity)}/#{escape(check)}"
      end

      # copied from Rack::Utils -- builds the query string for GETs
      def build_nested_query(value, prefix = nil)
        if value.respond_to?(:iso8601)
          raise ArgumentError, "value must be a Hash" if prefix.nil?
          "#{prefix}=#{escape(value.iso8601)}"
        else
          case value
          when Array
            value.map { |v|
              build_nested_query(v, "#{prefix}[]")
            }.join("&")
          when Hash
            value.map { |k, v|
              build_nested_query(v, prefix ? "#{prefix}[#{escape(k)}]" : escape(k))
            }.join("&")
          when String, Integer
            raise ArgumentError, "value must be a Hash" if prefix.nil?
            "#{prefix}=#{escape(value.to_s)}"
          else
            prefix
          end
        end
      end

      def escape(s)
        URI.encode_www_form_component(s)
      end

      # used for the JSON data hashes in POST, PUT, DELETE
      def prepare_nested_query(value)
        if value.respond_to?(:iso8601)
          value.iso8601
        else
          case value
          when Array
            value.map { |v| prepare_nested_query(v) }
          when Hash
            value.inject({}) do |memo, (k, v)|
              memo[k] = prepare_nested_query(v)
              memo
            end
          when Integer, TrueClass, FalseClass, NilClass
            value
          else
            value.to_s
          end
        end
      end

      def protocol_host_port
        self.base_uri =~ /^(?:(https?):\/\/)?([a-zA-Z0-9][a-zA-Z0-9\.\-]*[a-zA-Z0-9])(?::(\d+))?/i
        protocol = ($1 || 'http').downcase
        host = $2
        port = $3

        if port.nil? || port.to_i < 1 || port.to_i > 65535
          port = 'https'.eql?(protocol) ? 443 : 80
        else
          port = port.to_i
        end

        [protocol, host, port]
      end

      def build_uri(path, params = nil)
        pr, ho, po = protocol_host_port
        URI::HTTP.build(:protocol => pr, :host => ho, :port => po,
          :path => path, :query => (params.nil? || params.empty? ? nil : build_nested_query(params)))
      end

      def last_error=(error)
        @last_error = error
      end
    end
  end
end
