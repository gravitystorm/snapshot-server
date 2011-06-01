class ApplicationController < ActionController::Base
  protect_from_forgery

  # Report and error to the user
  # (If anyone ever fixes Rails so it can set a http status "reason phrase",
  #  rather than only a status code and having the web engine make up a
  #  phrase from that, we can also put the error message into the status
  #  message. For now, rails won't let us)
  def report_error(message, status = :bad_request)
    # Todo: some sort of escaping of problem characters in the message
    response.headers['Error'] = message

    if request.headers['X-Error-Format'] and
       request.headers['X-Error-Format'].downcase == "xml"
      result = OSM::API.new.get_xml_doc
      result.root.name = "osmError"
      result.root << (XML::Node.new("status") << interpret_status(status))
      result.root << (XML::Node.new("message") << message)

      render :text => result.to_s, :content_type => "text/xml"
    else
      render :text => message, :status => status
    end
  end
end
