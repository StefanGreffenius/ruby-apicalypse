class Apicalypse
  class Scope
    def initialize(klass)
      @klass = klass
    end

    def chain
      @chain ||= {}
    end

    def fields(*args)
      chain[:fields] = args.join(',')
      @klass
    end

    def exclude(*args)
      chain[:exclude] = args.join(',')
      @klass
    end

    def where(args)
      raise_on_invalid_scope_chain(args)

      chain[:where] = chain[:where] ? chain[:where].merge!(args) : args
      @klass
    end

    def limit(args)
      chain[:limit] = args
      @klass
    end

    def offset(args)
      chain[:offset] = args
      @klass
    end

    def sort(args)
      chain[:sort] = args
      @klass
    end

    def search(args)
      chain[:search] = format('"%<term>s"', term: args)
      @klass
    end

    def query(args)
      chain[:query] = args
      @klass
    end

    private

    def raise_on_invalid_scope_chain(scope)
      return unless chain[:where]

      if chain[:where].class != scope.class
        raise ScopeError, /Hash and String where scopes can't be combined./
      end
      if chain[:where].is_a?(String)
        raise ScopeError, /Multiple String where scopes are not supported./
      end
    end
  end
end
