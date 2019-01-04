require 'apicalypse/exceptions'
require 'apicalypse/request'
require 'apicalypse/scope'
require 'apicalypse/version'

class Apicalypse
  def initialize(uri, options = {})
    @scope = Scope.new(self)
    @request = Request.new(uri, options)
  end

  attr_reader :scope

  def fields(*args)
    @scope.fields(args)
  end

  def exclude(args)
    @scope.exclude(args)
  end

  def where(args)
    @scope.where(args)
  end

  def limit(args)
    @scope.limit(args)
  end

  def offset(args)
    @scope.offset(args)
  end

  def sort(args)
    @scope.sort(args)
  end

  def search(args)
    @scope.search(args)
  end

  def query(args)
    @scope.query(args)
  end

  def request
    @request.perform(@scope)
  end
end
