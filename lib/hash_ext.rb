class Hash
  def stringify_keys
    h = map do |k, v|
      v_str = if v.instance_of? Hash
        v.stringify_keys
      else
        v
      end

      [k.to_s, v_str]
    end
    h.to_h
  end
end
