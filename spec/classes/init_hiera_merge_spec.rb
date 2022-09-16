require 'spec_helper'
describe 'sudo', type: :class do
  describe 'hiera merge validations' do
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
      # see spec/fixtures/hiera for hiera data
      # hiera contains unittest2 as duplicate in both leves (unittest  & fqdn)
      let(:facts) { os_facts.merge({ unittest: 'hiera_merge_sudoers', fqdn: 'unit.test' }) }

      context 'on RedHat when hiera_merge_sudoers set to true' do
        let(:params) { { hiera_merge_sudoers: true } }

        it { is_expected.to have_sudo__fragment_resource_count(4) }
        it { is_expected.to contain_sudo__fragment('unittest1') } # from hiera/unittest/hiera_merge_sudoers.yaml
        it { is_expected.to contain_sudo__fragment('unittest2') } # from hiera/unittest/hiera_merge_sudoers.yaml & hiera/fqdn/unit.test.yaml
        it { is_expected.to contain_sudo__fragment('unittest3') } # from hiera/fqdn/unit.test.yaml
        it { is_expected.to contain_sudo__fragment('test') }      # from hiera/fqdn/unit.test.yaml

        it { is_expected.to contain_file('/etc/sudoers') }    # only needed for 100% resource coverage
        it { is_expected.to contain_file('/etc/sudoers.d') }  # only needed for 100% resource coverage
        it { is_expected.to contain_file('10_test') }         # only needed for 100% resource coverage
        it { is_expected.to contain_file('10_unittest1') }    # only needed for 100% resource coverage
        it { is_expected.to contain_file('20_unittest2') }    # only needed for 100% resource coverage
        it { is_expected.to contain_file('30_unittest3') }    # only needed for 100% resource coverage
        it { is_expected.to contain_package('sudo-package') } # only needed for 100% resource coverage
      end

      context 'on RedHat when hiera_merge_sudoers set to false' do
        let(:params) { { hiera_merge_sudoers: false } }

        it { is_expected.to have_sudo__fragment_resource_count(2) }
        it { is_expected.to contain_sudo__fragment('unittest1') }
        it { is_expected.to contain_sudo__fragment('unittest2') }
      end
    end
  end
end
