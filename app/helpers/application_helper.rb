module ApplicationHelper
  def error_messages_for(object)
    render(:partial => 'application/error_messages',
           :locals => {:object => object})
  end

  def json_string string
    if string.present?
      return string.gsub('"','\"')
    end
    return ''
  end

  def get_date_format date
    if date.present?
      return date.strftime('%Y-%m-%d')
    end
    return ''
  end

  def get_date_time_format date
    if date.present?
      return date.strftime('%d %b, %Y %H:%M')
    end
    return ''
  end
end