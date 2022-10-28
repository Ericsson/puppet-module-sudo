require 'spec_helper'
describe 'sudo', type: :class do
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
        'Array' => {
          name:    ['envkeep'],
          valid:   [['testing']],
          invalid: ['string', { 'ha' => 'sh' }, 3, 2.42, false],
          message: 'expects an Array',
        },
        'Boolean' => {
          name:    ['package_manage', 'config_dir_purge', 'sudoers_manage', 'requiretty', 'visiblepw', 'always_set_home',
                    'envreset', 'root_allow_all', 'includedir', 'include_libsudo_vas'],
          valid:   [true, false],
          invalid: ['false', 'string', ['array'], { 'ha' => 'sh' }, 3, 2.42],
          message: 'expects a Boolean value',
        },
        'Enum[present, absent]' => {
          name:    ['package_ensure'],
          valid:   ['present', 'absent'],
          invalid: [['array'], { 'ha' => 'sh' }, 3, 2.42, false],
          message: 'expects a match for Enum',
        },
        'Enum[present, absent, directory]' => {
          name:    ['config_dir_ensure'],
          valid:   ['present', 'absent', 'directory'],
          invalid: [['array'], { 'ha' => 'sh' }, 3, 2.42, false],
          message: 'expects a match for Enum',
        },
        'Hash' => {
          name:    ['sudoers'],
          valid:   [], # valid hashes are to complex to block test them here.
          invalid: ['string', 3, 2.42, ['array'], false],
          message: 'expects a Hash value',
        },
        'Optional[Boolean]' => {
          name:    ['always_query_group_plugin'],
          valid:   [true, false],
          invalid: ['false', 'string', ['array'], { 'ha' => 'sh' }, 3, 2.42],
          message: 'expects a value of type Undef or Boolean',
        },
        'Optional[String[1]]' => {
          name:    ['package_source'],
          valid:   ['string'],
          invalid: ['', ['array'], { 'ha' => 'sh' }, 3, 2.42, false],
          message: 'expects a value of type Undef or String(\[1\])?',
        },
        'Stdlib::Absolutepath' => {
          name:    ['package_adminfile', 'config_dir', 'config_file', 'libsudo_vas_location'],
          valid:   ['/unit/test'],
          invalid: ['../invalid', ['/in/valid'], { 'ha' => 'sh' }, 3, 2.42, false],
          message: 'expects a Stdlib::Absolutepath',
        },
        'Stdlib::Filemode' => {
          name:    ['config_dir_mode', 'config_file_mode'],
          valid:   ['0644', '0755', '0640', '1740'],
          invalid: [2770, '0844', '00644', 'string', ['array'], { 'ha' => 'sh' }, 3, 2.42, false, nil],
          message: 'expects a match for Stdlib::Filemode|Error while evaluating a Resource Statement',
        },
        'String[1]' => {
          name:    ['package', 'config_dir_group', 'config_file_group', 'config_file_owner', 'secure_path'],
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
