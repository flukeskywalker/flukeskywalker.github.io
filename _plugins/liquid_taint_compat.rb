module Liquid
  class Variable
    private

    def taint_check(context, obj)
      return unless obj.respond_to?(:tainted?) && obj.tainted?
      return if Template.taint_mode == :lax

      @markup =~ QuotedFragment
      name = Regexp.last_match(0)

      error = TaintedError.new("variable '#{name}' is tainted and was not escaped")
      error.line_number = line_number
      error.template_name = context.template_name

      case Template.taint_mode
      when :warn
        context.warnings << error
      when :error
        raise error
      end
    end
  end
end
