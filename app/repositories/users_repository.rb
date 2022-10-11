class UsersRepository
  def initialize(data_source:)
    @data_source = data_source
  end

  def query(order, fields)
    @generic_query = @data_source.order(order)
                                 .select(fields)
  end

  def get_all(page, limit)
    data = @generic_query.page(page).per(limit).all
    total = @generic_query.reselect('').count
    { data: data, total: total }
  end

  def index(page, limit, order, filter, fields)
    the_query = query order, fields
    the_filter = "%#{filter['name']}%"

    if filter['name']&.length&.positive?
      @generic_query = the_query.where(
        'name LIKE ? OR "users"."githubUser" LIKE ? OR "users"."organization" LIKE ? OR "users"."localization" LIKE ?', the_filter, the_filter, the_filter, the_filter
      ) else
          @generic_query = the_query
    end

    get_all page, limit
  end

  def show(id)
    find id
  end

  def create(data)
    data = @data_source.new(data)
    data.save
    data
  end

  def update(id, data)
    found_data = find id
    found_data.update(data)
    found_data
  end

  def find(id)
    @data_source.find(id)
  end

  def destroy(id)
    data = find id
    data.destroy
  end
end
