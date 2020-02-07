class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index 
    
    #session.clear
    
    # Source for dynamic header changes
    # https://stackoverflow.com/questions/9646815/conditionally-setting-css-style-from-ruby-controller
    sort_flag = params[:sort_by] || session[:sort_by] 
    if sort_flag == 'title'
      ordering = {:title => :asc}
      @title_header = 'hilite'
    elsif sort_flag == 'release_date'
      ordering = {:release_date => :asc}
      @date_header = 'hilite'
    end
    
        
    #get movies with selected ratings then handle displaying
    @all_ratings = Movie.get_ratings()
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    # account for no cookies condition, display all for default
    if @selected_ratings == {}
      @selected_ratings = Hash.new
      @all_ratings.each do |current_rating|
        @selected_ratings[current_rating] = 1
      end
    end
      
    # flag to check for redirect  
    redirect_flag = false
    
    # check for redirect
    if session[:sort_by] != params[:sort_by]
      session[:sort_by] = sort_flag
      redirect_flag = true
    end  
    
    if session[:ratings] != params[:ratings]
      session[:ratings] = @selected_ratings
      redirect_flag = true
    end 
    
    if redirect_flag == true
      flash.keep
      redirect_to :sort_by => sort_flag, :ratings => @selected_ratings and return
    end
    
    @movies = Movie.with_ratings(@selected_ratings).order(ordering)
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
