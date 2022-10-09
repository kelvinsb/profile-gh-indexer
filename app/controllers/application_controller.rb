class ApplicationController < ActionController::API
  def normalize_filters
    params_page = params[:page]
    params_limit = params[:limit]
    params_order = params[:order]
    params_filter = params[:filter]
    params_fields = params[:fields]

    @current = CustomFilters.new(params_page, params_limit, params_order, params_filter, params_fields)
  end

  def list_data
    @current.list_data
  end

  def meta_helper(total, meta)
    { total: total, page: meta[:page], limit: meta[:limit], count: meta[:count] }
  end

  def meta(page, limit, total)
    @meta = { page: page, limit: limit, count: total }
  end

  def default_return(data, meta)
    {
      meta: meta_helper(data.length, meta),
      data: data
      # meta: { **@meta }
    }
  end
end
