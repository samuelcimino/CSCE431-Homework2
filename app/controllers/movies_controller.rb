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
    @all_ratings = Movie.get_ratings
	ratings_checked = []
	
	
	if params["ratings"]
	  @movies = Movie.none
	  keys = params["ratings"].keys
	
	  for k in keys
		@movies += Movie.where("rating = ?", k)
		ratings_checked.push(k)
      end
	else
	  @movies = Movie.all
	  ratings_checked = ['G','PG','PG-13','R']
	end
	
	
	
	#@movies = Movie.all
    if params["title"]
	  @movies = @movies.order("title")
	elsif params["release"]
	  @movies = @movies.order("release_date")
	#else
	#  @movies = Movie.all
	end

    @ratings_checked = ratings_checked
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
  
  def sort_title
    @movies = Movie.all.order("title")
  end

end
