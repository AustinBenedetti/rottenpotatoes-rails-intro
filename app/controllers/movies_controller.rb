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
    
    #get movies with selected ratings then handle displaying
    @all_ratings = Movie.get_ratings()
    @selected_ratings = params[:ratings] #|| session[:ratings] # TODO: UNDO FOR MEMORY

    
    # Source for dynamic header changes
    # https://stackoverflow.com/questions/9646815/conditionally-setting-css-style-from-ruby-controller
    sort_flag = params[:sort_by] #|| session[:sort_by] # TODO: UNDO FOR MEMORY
    if sort_flag == 'title'
      ordering = {:title => :asc}
      @title_header = 'hilite'
      @movies = Movie.order(ordering).all
    elsif sort_flag == 'release_date'
      ordering = {:release_date => :asc}
      @date_header = 'hilite'
      @movies = Movie.order(ordering).all
    else
      @movies = Movie.all
    end
      
    # store session hash for refresh
    # session[:sort_by] = sort_flag
    # session[:ratings] = @selected_ratings
    
    
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
