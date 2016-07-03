class Jenum

  attr_accessor :name
  attr_accessor :columns
  attr_accessor :values

  def initialize(name,cols=[ENUM_COLUMN_ID, ENUM_COLUMN_NAME])
    self.name = name
    self.columns = cols
  end

  def set_values vals
    self.values = vals
  end

  def get_by_id id
    values.each do |value|
      if value[0] == id
        return value
      end
    end

    return nil
  end

  def get_name_by_id id
    values.each do |value|
      if value[0] == id
        return value[1]
      end
    end

    return ""
  end

  def is_valid_id id
    values.each do |value|
      if value[0] == id
        return true
      end
    end
    return false
  end

  def get_all_values
    return values
  end

end