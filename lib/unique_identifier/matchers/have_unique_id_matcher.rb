module UniqueIdentifier
  module Shoulda
    module Matchers
      # Example:
      #   describe Order do
      #     it { should have_unique_id(:number) }
      #   end
      def have_unique_id name
        HaveUniqueIdMatcher.new(name)
      end

      class HaveUniqueIdMatcher
        def initialize column_name
          @column_name = column_name
          @failure_messages = []
        end

        def matches? subject
          @subject = subject
          @subject = @subject.class unless Class === @subject
          responds? && has_column? && block_returns_unique?
        end

        def failure_message
          base_msg = "Should call `unique_id` for column `#{@column_name}`"
          @failure_messages.unshift(base_msg)
          @failure_messages.join("\n")
        end

        def failure_message_when_negated
          "Should not call `unique_id` for column `#{@column_name}`"
        end
        alias negative_failure_message failure_message_when_negated

        def description
          "have `unique_id` declaration for #{@column_name}"
        end

        protected

        def responds?
          @subject.instance_methods.include?(:generate_unique_id)
        end

        def has_column?
          @subject.column_names.include?("#{@column_name}")
        end

        def block_returns_unique?
          results = Array.new(3) do
            @subject.const_get('UNIQUE_IDENTIFIER_BLOCK').call
          end

          unless valid = results.detect{|x| results.count(x) > 1 }.blank?
            @failure_messages << "- `unique_id` block argument must return unique values"
          end
          valid
        end
      end
    end
  end
end
