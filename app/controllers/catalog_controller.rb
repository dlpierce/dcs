# -*- encoding : utf-8 -*-
#
class CatalogController < ApplicationController
  include Blacklight::Marc::Catalog

  include Blacklight::Catalog

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      :qt => 'search',
      :rows => 10
    }

    config.advanced_search = {
        :qt => 'standard'
    }

    # solr path which will be added to solr base url before the other solr params.
    #config.solr_path = 'select'

    # items to show per page, each number in the array represent another option to choose from.
    #config.per_page = [10,20,50,100]

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    #config.default_document_solr_params = {
    #  :qt => 'document',
    #  ## These are hard-coded in the blacklight 'document' requestHandler
    #  # :fl => '*',
    #  # :rows => 1
    #  # :q => '{!raw f=id v=$id}'
    #}

    # solr field configuration for search results/index views
    config.index.title_field = 'title_t'
    config.index.display_type_field = 'format'
    config.index.show_link_field = 'context_url_s'
    config.index.thumbnail_field = 'preview_url_s'


    # solr field configuration for document/show views
    #config.show.title_field = 'title_display'
    #config.show.display_type_field = 'format'
    # config.show.route = {action: :purl}

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    config.add_facet_field 'format', :label => 'Format'
    config.add_facet_field 'coll_id', :label => 'Collection', :limit => 15
    config.add_facet_field 'source', :label => 'Source', :limit => 15
    # config.add_facet_field 'pub_date', :label => 'Publication Year', :single => true
    config.add_facet_field 'subject_topic_facet', :label => 'Topic', :limit => 15
    config.add_facet_field 'subject_geographic_facet', :label => 'Place', :limit => 15
    config.add_facet_field 'name_facet', :label => 'Creator', :limit => 15
    config.add_facet_field 'genre_facet', :label => 'Genre', :limit => 15
    config.add_facet_field 'year', :label => 'Year', :limit => 15
    # config.add_facet_field 'language_facet', :label => 'Language', :limit => true
    # config.add_facet_field 'lc_1letter_facet', :label => 'Call Number'
    # config.add_facet_field 'subject_era_facet', :label => 'Era'

    # config.add_facet_field 'example_pivot_field', :label => 'Pivot Field', :pivot => ['format', 'language_facet']

    # config.add_facet_field 'example_query_facet_field', :label => 'Publish Date', :query => {
    #    :years_5 => { :label => 'within 5 Years', :fq => "pub_date:[#{Time.now.year - 5 } TO *]" },
    #    :years_10 => { :label => 'within 10 Years', :fq => "pub_date:[#{Time.now.year - 10 } TO *]" },
    #    :years_25 => { :label => 'within 25 Years', :fq => "pub_date:[#{Time.now.year - 25 } TO *]" }
    # }


    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'title_t', :label => 'Title'
    config.add_index_field 'coll_id', :label => 'Collection'
    config.add_index_field 'source', :label => 'Source'
    config.add_index_field 'format', :label => 'Format'
    # config.add_index_field 'subject_geographic_t', :label => 'Place'
    # config.add_index_field 'genre_t', :label => 'Genre'
    # config.add_index_field 'abstract_t', :label => 'Abstract'
    config.add_index_field 'item_id', :label => 'Item ID'


    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field 'title_t', :label => 'Title'
    config.add_show_field 'coll_id', :label => 'Collection'
    config.add_show_field 'source', :label => 'Source'
    config.add_show_field 'format', :label => 'Format'
    config.add_show_field 'item_id', :label => 'Item ID'


    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', :label => 'Keywords' do |field|
      field.include_in_simple_select = true
      field.include_in_advanced_search = false
    end

    config.add_search_field 'All Fields' do |field|
      field.solr_parameters = {:qf => "metatext"}
      field.include_in_simple_select = false
      field.include_in_advanced_search = true
    end

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field('Title') do |field|
      field.solr_parameters = {:qf => "title_t"}
      field.include_in_simple_select = false
      field.include_in_advanced_search = true

      # solr_parameters hash are sent to Solr as ordinary url query params.
      # field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      # field.solr_local_parameters = {
      #   :qf => '$title_qf',
      #   :pf => '$title_pf'
      # }
    end

    config.add_search_field('Collection') do |field|
      field.solr_parameters = {:qf => "coll_id"}
      field.include_in_simple_select = false
      field.include_in_advanced_search = true
      # field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
      # field.solr_local_parameters = {
      #   :qf => '$coll_qf',
      #   :pf => '$coll_pf'
      # }
    end

    config.add_search_field('Topic') do |field|
      field.solr_parameters = {:qf => "subject_topic_t"}
      field.include_in_simple_select = false
      field.include_in_advanced_search = true
      # field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
      # field.solr_local_parameters = {
      #   :qf => '$coll_qf',
      #   :pf => '$coll_pf'
      # }
    end

    config.add_search_field('Creator') do |field|
      field.solr_parameters = {:qf => "name_t"}
      field.include_in_simple_select = false
      field.include_in_advanced_search = true
      # field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
      # field.solr_local_parameters = {
      #   :qf => '$coll_qf',
      #   :pf => '$coll_pf'
      # }
    end

    config.add_search_field('Public Collection?') do |field|
      field.solr_parameters = {:qf => "coll_ispublic"}
      field.include_in_simple_select = false
      field.include_in_advanced_search = true
      # field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
      # field.solr_local_parameters = {
      #   :qf => '$coll_qf',
      #   :pf => '$coll_pf'
      # }
    end

    # # Specifying a :qt only to show it's possible, and so our internal automated
    # # tests can test it. In this case it's the same as
    # # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    # config.add_search_field('source') do |field|
    #   # field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
    #   #field.qt = 'search'
    #   # field.solr_local_parameters = {
    #   #   :qf => '$source_qf',
    #   #   :pf => '$source_pf'
    #   # }
    # end
    #
    # config.add_search_field('item_id') do |field|
    #   field.label = 'Item ID'
    # end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc', :label => 'relevance'
    # config.add_sort_field 'score desc, year desc, title_sort_s asc', :label => 'relevance'
    # config.add_sort_field 'year desc, title_sort_s asc', :label => 'year'
    # config.add_sort_field 'author_sort asc, title_sort_s asc', :label => 'author'
    # config.add_sort_field 'title_sort_s asc, year desc', :label => 'title'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end

  # If solr contains a context_url, redirect to it.
  # Otherwise, do the normal Blacklight stuff.
  # Disabled in favor of rendering links instead of redirects.
  # def show
  #   @response, @document = get_solr_response_for_doc_id params[:id]
  #
  #   show_purl = @document['context_url_s'].try :first
  #
  #   if show_purl.blank?
  #     super
  #   else
  #     redirect_to show_purl
  #   end
  # end

end
