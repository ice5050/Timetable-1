class StudentsController < ApplicationController
  def index
    @url = params[:url].to_s
    @code = params[:code]

    @page = Nokogiri::HTML(open(@url))   
    @stu_id_selected = @page.css("td[width='87']").text

    if @url.length == 102
        @stu_id_selected = @page.css("td[width='87']").text
    elsif @url.size == 108
        @stu_id_selected = @page.css("td[width='74']").text
    end 


    i = 0
    j = 8

    @stu_id_selected = @stu_id_selected[12..-1]
    @url_img = []
    @stu_id = []

    while j < @stu_id_selected.to_s.length do
        id = @stu_id_selected[i..j].to_f
        @stu_id << id.to_i                                                  
        if id % 2 == 0
            id = ((id + 573190) / 2).to_i.to_s
        else
            id = ((id + 573190) / 2).to_i.to_s + "a"
        end

        @url_img << id
        i += 9
        j += 9
    end

  end

  def create
    url = params[:url]
    code = params[:code]
    redirect_to students_path(url: url, code: code)
  end

  def stu_info
    @stu_id = params[:id]
    url = "https://www3.reg.cmu.ac.th/stdsearch/index.php?file=stdnow"

    @response = RestClient.post(url, {'key1' => @stu_id, 'button_search' => 0 })
    page = Nokogiri::HTML(@response.to_s)
    @page = page.css("table")
   
  end
end
