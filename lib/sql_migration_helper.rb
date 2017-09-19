require 'ostruct'

module SQLMigrationHelper
  def up
    execute extracted_code_hash.up
  end

  def down
    execute extracted_code_hash.down
  end

  def base_name
    @base_name ||= "#{self.class.name.underscore}.sql"
  end

  def sql_command_file
    File.join('db', 'migrate', 'sql', base_name)
  end

  def code
    @code ||= IO.read(sql_command_file)
  end

  def extracted_code
    code.scan(/^--#\s:(\w*$)(.*?)^--#/m).flatten
  end

  def extracted_code_hash
    OpenStruct.new(Hash[*extracted_code])
  end
end
