module Flapjack
  class ArgumentValidator

    attr_reader :query

    def initialize(query = {})
      @errors = []
      @query = query
    end

    def validate(args)
      args = args.dup
      validations = args.delete(:as)
      validations = [validations] unless validations.is_a?(Array)

      if elements = args[:query]
        elements = [elements] unless elements.is_a?(Array)
        validations.each do |validation|
          __send__(validation.to_s.downcase, *elements)
        end
      end

      raise ArgumentError.new(@errors.join('; ')) unless @errors.empty?
    end

    private

    def time(*elements)
      elements.each do |element|
        if target = @query[element]
          next if target.respond_to?(:iso8601) || (target.is_a?(String) &&
            (begin; Time.iso8601(target); true; rescue ArgumentError; false; end))
          @errors << "'#{target}' should be a time object or ISO 8601-formatted string."
        end
      end
    end

    def required(*elements)
      elements.each do |element|
        @errors << "'#{element}' is required." if @query[element].nil?
      end
    end

    def respond_to?(name, include_private = false)
      !classify_name(name).nil? || super
    end

    def method_missing(name, *args)
      return super unless klass = classify_name(name)
      elements = args
      elements.each do |element|
        @errors << "'#{element}' is expected to be a #{klass}" unless @query[element].is_a?(klass)
      end
    end

    def classify_name(name)
      class_name = name.to_s.split('_').map(&:capitalize).join
      Module.const_get(class_name)
    rescue NameError
    end
  end
end
