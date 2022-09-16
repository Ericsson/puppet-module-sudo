require 'spec_helper'
describe 'sudo::fragment', type: :define do
  let(:title) { 'test' }
  let(:pre_condition) do
    'include sudo'
  end

  describe 'variable type and content validations' do
    # The following tests are OS independent, so we only test one supported OS
    redhat = {
      supported_os: [
        {
          'operatingsystem'        => 'RedHat',
          'operatingsystemrelease' => ['7'],
        },
      ],
    }

    on_supported_os(redhat).each do |_os, os_facts|
      let(:facts) { os_facts }

      validations = {
        'Enum[present, absent]' => {
          name:    ['ensure'],
          valid:   ['present', 'absent'],
          invalid: [['array'], { 'ha' => 'sh' }, 3, 2.42, false],
          messge: 'expects a match for Enum',
        },
        'Integer' => {
          name:    ['priority'],
          valid:   [20],
          invalid: ['3', 'string', ['array'], { 'ha' => 'sh' }, 2.42, false],
          message: 'expects an Integer',
        },
        'Optional[String[1]]' => {
          name:    ['content'],
          valid:   ['string'],
          invalid: ['', ['array'], { 'ha' => 'sh' }, 3, 2.42, false],
          message: 'expects a value of type Undef or String(\[1\])?',
        },
        'Stdlib::Filesource' => {
          name:    ['source'],
          valid:   ['puppet:///test', '/test/ing', 'file:///test/ing'],
          invalid: [['array'], { 'ha' => 'sh' }, 3, 2.42, false],
          message: 'expects a Stdlib::Filesource',
        },
        'Stdlib::Absolutepath' => {
          name:    ['config_dir'],
          valid:   ['/sudoers/file', '/folder'],
          invalid: ['../invalid', ['/in/valid'], { 'ha' => 'sh' }, 3, 2.42, false],
          message: 'expects a Stdlib::Absolutepath',
        },
        'String[1]' => {
          name:    ['config_dir_group'],
          valid:   ['string'],
          invalid: ['', ['array'], { 'ha' => 'sh' }, 3, 2.42, false],
          message: 'expects a String(\[1\])? value',
        },
      }

      validations.sort.each do |type, var|
        var[:name].each do |var_name|
          var[:params] = {} if var[:params].nil?
          var[:valid].each do |valid|
            context "when #{var_name} (#{type}) is set to valid #{valid} (as #{valid.class})" do
              let(:params) { [var[:params], { "#{var_name}": valid, }].reduce(:merge) }

              it { is_expected.to compile }
            end
          end

          var[:invalid].each do |invalid|
            context "when #{var_name} (#{type}) is set to invalid #{invalid} (as #{invalid.class})" do
              let(:params) { [var[:params], { "#{var_name}": invalid, }].reduce(:merge) }

              it 'fail' do
                expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{#{var[:message]}})
              end
            end
          end
        end # var[:name].each
      end # validations.sort.each
    end # describe 'variable type and content validations'
  end
end
