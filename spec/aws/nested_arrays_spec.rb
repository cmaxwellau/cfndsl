# frozen_string_literal: true

require 'spec_helper'

describe CfnDsl::CloudFormationTemplate do
  subject(:template) { described_class.new }

  describe '#Nested_Arrays' do
    it 'ensure nested arrays are not duplicated' do
      template.DirectoryService_SimpleAD(:Test) do
        VpcSettings do
          SubnetId %w[subnet-a subnet-b]
        end
      end

      puts template.to_json
      expect(template.to_json).to include('"SubnetIds":["subnet-a","subnet-b"]}')
      expect(template.to_json).not_to include('"SubnetIds":[["subnet-a","subnet-b"],["subnet-a","subnet-b"]]')
    end

    it 'check multiple invocations work' do
      template.DirectoryService_SimpleAD(:Test) do
        VpcSettings do
          SubnetId 'subnet-a'
          SubnetId 'subnet-b'
        end
      end

      expect(template.to_json).to include('"SubnetIds":["subnet-a","subnet-b"]}')
    end

    it 'check multiple invocation with arrays works' do
      template.DirectoryService_SimpleAD(:Test) do
        VpcSettings do
          SubnetId %w[subnet-a subnet-b]
          SubnetId %w[subnet-c subnet-d]
        end
      end

      expect(template.to_json).to include('"SubnetIds":["subnet-a","subnet-b","subnet-c","subnet-d"]')
    end
  end
end
