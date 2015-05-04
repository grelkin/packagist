#
# Cookbook Name:: packagist
# Attributes:: default
#
# Copyright (C) Sebastian Brandt <sebbrandt87+git@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#<> restart mysql server on configuration changes
default['percona']['auto_restart'] = false
default['percona']['skip_passwords'] = true
#<> redis datadir
default['redisio']['default_settings']['datadir'] = '/data/redis'
#<> redis server settings
default['redisio']['servers'] = [
  {
    'name' => 'master',
    'port' => '6379',
    'unixsocket' => '/tmp/redis.sock',
    'unixsocketperm' => '755'
  }
]

#<> nginx repo source
default['nginx']['repo_source'] = 'nginx'
default['nginx']['default_root'] = '/opt/packagist/web'

#<> php source
default['php']['install_method'] = 'source'
default['php']['url'] = 'http://de1.php.net/get'
default['php']['version'] = '5.6.8'
default['php']['checksum'] = 'c5b1c75c5671c239473eb611129f33ac432a55a1c341990b70009a2aa3b8dbc3'

#<> php-fpm version
default['php-fpm']['pools'] = {
    'www' => {
        :enable => 'true',
        :listen => '/tmp/www.sock',
        :process_manager => 'dynamic',
        :max_requests => 1000,
        :php_options => { 'php_admin_flag[log_errors]' => 'on', 'php_admin_value[memory_limit]' => '32M' }
    }
}


default['packagist']['config']['parameters'] = {}
