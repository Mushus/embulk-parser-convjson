require 'json'

module Embulk
	module Parser
		class Convjson < ParserPlugin
			Plugin.register_parser("convjson", self)

			def self.transaction(config, &control)
				# 設定の読み込み
				task = {
                    :foreach => config.param('foreach', :string),
					:schema => config.param('schema', :array)
				}

                # レコードのカラム(詳細は schema 定義に従う)
                columns = task[:schema].each_with_index.map do |column, index|
                    Column.new(index, column["name"], column["type"].to_sym)
                end
p "here"
				yield(task, columns)
			end

			def run(file_input)
				# ファイル毎に1レコード
                while file = file_input.next_file
                    json = JSON.load(file.read)
                    foreach = evaluate_foreach(json, @task["foreach"])
                    case foreach.class.to_s
                    when "Array"
                        foreach.each_with_index.map do |column, index|
                            @page_builder.add(make_record(json, index, column, index))
                        end
                    when "Hash"
                        foreach.each_with_index do |(key, value), index|
                            @page_builder.add(make_record(json, index, value, index))
                        end
                    else
                        p "here"
                        @page_builder.add(make_record(json, nil, nil, nil))
                    end
                end
				page_builder.finish
			end

            # レコードを作成
            def make_record(json, key, value, index)
                schema = @task["schema"]
                schema.each_with_index.map do |column|
                    name = column['name'];
                    exp = column['exp'];
                    type = column['type'];
					format = person['format']? ? column['format']: nil;
                    convert_type(evaluate_exp(json, key, value, index, exp), type, format)
                end
            end

            # 式を評価する
            def evaluate_exp(data, _key, _value, _index, exp)
                # eval 内で json を使えるように
                json = data
                key = _key
                value = _value
				index = _index
                eval(exp)
            end

            # foreachの式を評価する
            def evaluate_foreach(data, exp)
                json = data
                eval(exp)
            end

            # valをtype型に変換する
            def convert_type(val, type, format)
                case type
                when "string"
                    val
                when "long"
                    val.to_i
                when "double"
                    val.to_f
                when "boolean"
                    ["yes", "true", "1"].include?(val.downcase)
                when "timestamp"
                    val.empty? ? nil : Time.strptime(val, format)
                else
                    raise "Unsupported type #{type}"
                end
            end

		end
	end
end
