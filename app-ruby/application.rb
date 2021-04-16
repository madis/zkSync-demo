require 'sinatra'
require 'sinatra/reloader'
require 'tilt'
require_relative './zk_sync'

class Application < Sinatra::Base
  set :bind, '0.0.0.0'
  set :port, 3999
  Tilt.register Tilt::ERBTemplate, 'html.erb'
  register Sinatra::Reloader

  get '/' do
    erb :index
  end

  get '/test' do
    <<~EOS
      path: #{ZkSync.manifest_path}
      exists? #{File.exists?(ZkSync.manifest_path)}
      Dir.pwd #{Dir.pwd}
    EOS
  end

  post '/invoices' do
    issuer = params[:issuer] || '0x74AF123Ef7013E821733259F2a01558A4FABf26B'
    payer = params[:payer] || '0xC238fa6CcC9D226e2C49644b36914611319fc3Ff'
    result = ZkSync.raise_invoice(id: params[:invoice_id], amount: params[:amount], issuer: issuer, payer: payer)
    erb :index, locals: {message: result}
  end

  get '/invoices/query' do
    result = ZkSync.get_invoice(id: params[:invoice_id])
    erb :index, locals: {message: result}
  end
end
