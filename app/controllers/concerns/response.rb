module Response
  def json_response(object, status = :ok)
    if %i(ok created).include?(status)
      if stale?(last_modified: object.updated_at, public: true)
        render "show.json", status: status and return
      end
    else
      render json: object, status: status and return
    end
  end
end
