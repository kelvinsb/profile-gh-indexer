class CustomFilters
  def initialize(page, limit, order, filter, _fields)
    @page = normalize_page(page)
    @limit = normalize_limit(limit)
    @order = normalize_order(order)
    @filter = normalize_filter(filter)
  end

  def default_hash_allowed
    [ActionController::Parameters, Hash]
  end

  def normalize_page(page)
    check_and_default_integer(page, 1)
  end

  def normalize_limit(limit)
    check_and_default_integer(limit, 10)
  end

  def normalize_order(order)
    default_field = 'id'

    return default_field unless [*default_hash_allowed, nil].member? order.class

    valid_orders = %w[desc asc]
    pre_normalized_order = order&.to_enum&.to_h

    items = pre_normalized_order&.filter do |_ord_key, ord_value|
      valid_orders.include? ord_value
    end

    items || default_field
  end

  def normalize_filter(filter)
    default_filter = {}

    return default_filter unless [*default_hash_allowed, nil].member? filter.class

    filter&.to_enum&.to_h || default_filter.to_enum.to_h
  end

  def list_data
    [@page, @limit, @order, @filter]
  end

  def tranform_to_integer(variable, initial_value = 3)
    return variable.to_i if variable.is_a? String
    return variable.to_i if variable.is_a? Numeric

    initial_value
  end

  def check_zero_and_negative(variable, initial_value)
    return initial_value if variable.zero?
    return initial_value if variable.negative?

    variable
  end

  def check_and_default_integer(variable, initial_value = 1)
    integer_number = tranform_to_integer(variable, initial_value)
    check_zero_and_negative(integer_number, initial_value)
  end
end
