require 'fileutils'
require 'json'

class ZkSync
  def self.raise_invoice(id:, amount:, issuer:, payer:)
    call_zargo(:raiseInvoice, invoiceId: id, amount: amount, issuer: issuer, payer: payer)
  end

  def self.get_invoice(id:)
    query_zargo(:getInvoice, invoiceId: id)
  end

  private

  def self.query_zargo(method, **arguments)
    with_input_file(method, arguments) { zargo(type: :query, method: method) }
  end

  def self.call_zargo(method, **arguments)
    with_input_file(method, arguments) { zargo(type: :call, method: method) }
  end

  CONTRACT_ADDRESS = "0xbaf52e3e7bfec76d3a9cadf88f097ae9f89c8072"
  ALLOWED_TYPES = [:call, :query]
  def self.zargo(type:, method:)
    raise "Only #{ALLOWED_TYPES} allowed. You passed #{type}" unless ALLOWED_TYPES.include?(type)
    command = "zargo #{type} --address=#{CONTRACT_ADDRESS} --manifest-path=#{manifest_path} --network=rinkeby --method=#{method}"
    `zargo #{type} --address=#{CONTRACT_ADDRESS} --manifest-path=#{manifest_path} --network=rinkeby --method=#{method}`
  end

  def self.with_input_file(method, arguments)
    FileUtils.cp input_json_path, temp_input_json_path
    contents = JSON.parse(File.read(input_json_path))
    contents['arguments'] = contents['arguments'].merge({method.to_s => arguments})
    File.open(input_json_path, 'w') { |f| f.write(JSON.pretty_generate contents) }
    command_output = yield
    FileUtils.mv temp_input_json_path, input_json_path # Put back the original file

    command_output
  end

  def self.manifest_path
    contract_root_path + '/invoices/Zargo.toml'
  end

  def self.input_json_path
    contract_root_path + '/invoices/data/input.json'
  end

  def self.contract_root_path
    File.expand_path(Dir.pwd + '/../contracts')
  end

  def self.temp_input_json_path
    '/tmp/zk-sync-input-temp.json'
  end
end
