# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'timeout'
require 'socket'

class HPProxy
  include Singleton

  attr_accessor :enabled, :verbose, :http, :http_port, :http_protocol, :https,
                :https_port, :https_protocol, :socks, :socks_port,
                :no_proxy_ips

  def initialize()
    unless Vagrant.has_plugin?('vagrant-proxyconf')
      raise 'vagrant-proxyconf plugin is not installed!'
    end

    @enabled = :false
    @verbose = false
    @http = 'proxy.bbn.hp.com'
    @http_port = 8080
    @http_protocol = 'http'
    @https = 'proxy.bbn.hp.com'
    @https_port = 8080
    @https_protocol = 'http'
    @socks = 'proxy.bbn.hp.com'
    @socks_port = 1080
    @no_proxy_ips = [ 'localhost', '127.0.0.1', '.hpcloud.net' ]
  end

  # true, false or :auto
  def enabled=(value)
    @enabled = value == :auto ? value : (value == true)
    begin
      if @enabled == :auto
        puts 'Autodetecting proxy settings...' if @verbose
        timeout(2) do
          s = TCPSocket.new @http, @http_port
        end

        puts 'Proxy presence detected' if @verbose
        @enabled = true
      end
    rescue Timeout::Error
      puts 'Timed out detecting proxy' if @verbose
      @enabled = false
    end

    return @enabled
  end

  def setup(config)
    if @enabled == true
      puts 'Using proxies' if @verbose
      config.proxy.http = "#{@http_protocol}://#{@http}:#{@http_port}/"
      config.proxy.https = "#{@https_protocol}://#{@https}:#{@https_port}/"
      config.proxy.no_proxy = @no_proxy_ips.join ','
    else
      puts 'Not using proxies' if @verbose
    end
  end

end

$hp_proxy = HPProxy.instance
