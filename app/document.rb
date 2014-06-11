require 'princely'

class Document

  def generate! token, url, type
    princely = Princely.new options

    path     = 'files/'
    name     = token + '.' + type
    content  = get_content url, name
    file     = path + name

    register(token, file) { princely.pdf_from_string_to_file(content, file) }
  end

  private

  def register token, file
    Registry.instance.start! token, file
    yield
    Registry.instance.finish! token
  end

  def options
    options = {
      :log_file => Pathname.new(File.expand_path('../../', __FILE__)).join('log', 'prince.log'),
    }
  end

  def get_content url, name
    result  = system("curl -s -o public/#{name} '#{url}'")
    content = File.open("public/#{name}").read.to_s
  end

end
