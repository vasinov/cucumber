require "cucumber/filters/gated_receiver"
require "cucumber/filters/tag_limits/test_case_index"
require "cucumber/filters/tag_limits/verifier"

module Cucumber
  module Filters
    class TagLimitExceededError < StandardError
      def initialize(*limit_breaches)
        super(limit_breaches.map(&:to_s).join("\n"))
      end
    end

    class TagLimits
      def initialize(tag_limits, receiver)
        @gated_receiver = GatedReceiver.new(receiver)
        @test_case_index = TestCaseIndex.new
        @verifier = Verifier.new(tag_limits)
      end

      def test_case(test_case)
        gated_receiver.test_case(test_case)
        test_case_index.add(test_case)
        self
      end

      def done
        verifier.verify!(test_case_index)
        gated_receiver.done
        self
      end

      private

      attr_reader :gated_receiver
      attr_reader :test_case_index
      attr_reader :verifier
    end

  end
end
