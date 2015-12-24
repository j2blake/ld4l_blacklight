# -*- encoding : utf-8 -*-
class CatalogController < ApplicationController  

  include Blacklight::Catalog

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = { 
      :qt => 'search',
      :rows => 10 
    }
    
    # solr path which will be added to solr base url before the other solr params.
    #config.solr_path = 'select' 
    
    # items to show per page, each number in the array represent another option to choose from.
    #config.per_page = [10,20,50,100]

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SearchHelper#solr_doc_params) or
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
    config.index.title_field = 'title_display'
    config.index.display_type_field = 'format'

    # solr field configuration for document/show views
    #config.show.title_field = 'title_display'
    #config.show.display_type_field = 'format'

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
    config.add_facet_field 'pub_date', :label => 'Publication Year', :single => true
    config.add_facet_field 'subject_topic_facet', :label => 'Topic', :limit => 20 
    config.add_facet_field 'language_facet', :label => 'Language', :limit => 20, :sort => 'index'
    config.add_facet_field 'lc_1letter_facet', :label => 'Call Number' 
    config.add_facet_field 'subject_geo_facet', :label => 'Region' 
    config.add_facet_field 'subject_era_facet', :label => 'Era'  
    
    config.add_facet_field 'source_site_facet', :label => 'Library'  

    config.add_facet_field 'example_pivot_field', :label => 'Pivot Field', :pivot => ['format', 'language_facet']
      
    config.add_facet_field 'example_query_facet_field', :label => 'Publish Date', :query => {
       :years_5 => { :label => 'within 5 Years', :fq => "pub_date:[#{Time.now.year - 5 } TO *]" },
       :years_10 => { :label => 'within 10 Years', :fq => "pub_date:[#{Time.now.year - 10 } TO *]" },
       :years_25 => { :label => 'within 25 Years', :fq => "pub_date:[#{Time.now.year - 25 } TO *]" }
    }

    config.add_facet_field 'category_facet', :label => 'Category', :show => false, :sort => 'index'
    config.add_facet_field 'class_facet', :label => 'Class', :show => false, :sort => 'index'
    config.add_facet_field 'category_class_pivot_field', :label => 'Category/Class', :pivot => ['category_facet', 'class_facet']

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display 
    config.add_index_field 'title_t', :label => 'Title'
    config.add_index_field 'title_display', :label => 'Title'
    config.add_index_field 'title_vern_display', :label => 'Title'
    config.add_index_field 'author_display', :label => 'Author'
    config.add_index_field 'author_vern_display', :label => 'Author'
    config.add_index_field 'format', :label => 'Format'
    config.add_index_field 'language_facet', :label => 'Language'
    config.add_index_field 'published_display', :label => 'Published'
    config.add_index_field 'published_vern_display', :label => 'Published'
    config.add_index_field 'lc_callnum_display', :label => 'Call number'
    
    config.add_index_field 'class_display', :label => 'Class'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display 
    config.add_show_field 'title_t', :label => 'Title'
    config.add_show_field 'title_display', :label => 'Title'
    config.add_show_field 'title_vern_display', :label => 'Title'
    config.add_show_field 'subtitle_display', :label => 'Subtitle'
    config.add_show_field 'subtitle_vern_display', :label => 'Subtitle'
    config.add_show_field 'author_display', :label => 'Author'
    config.add_show_field 'author_vern_display', :label => 'Author'
    config.add_show_field 'format', :label => 'Format'
    config.add_show_field 'url_fulltext_display', :label => 'URL'
    config.add_show_field 'url_suppl_display', :label => 'More Information'
    config.add_show_field 'language_display', :label => 'Language',  :helper_method => 'multiline_helper'
    config.add_show_field 'published_display', :label => 'Published'
    config.add_show_field 'published_vern_display', :label => 'Published'
    config.add_show_field 'lc_callnum_display', :label => 'Call number'
    config.add_show_field 'isbn_display', :label => 'ISBN'
    config.add_show_field 'material_type_display', :label => 'Smaterials'
    #config.add_show_field 'class_facet', :label => 'Class',  :helper_method => 'multiline_helper'
    
    config.add_show_field 'source_site_display', :label => 'Library'
    config.add_show_field 'class_display', :label => 'Class',  :helper_method => 'multiline_helper'
    config.add_show_field 'alt_titles_t', :label => 'Alternate title',  :helper_method => 'multiline_helper'
    config.add_show_field 'instance_of_token', :label => 'Instance of', :helper_method => 'link_for_my_local_tokens'
    config.add_show_field 'instance_token', :label => 'Instance', :helper_method => 'show_instances'
    config.add_show_field 'subject_token', :label => 'Topic', :helper_method => 'show_subjects'
    config.add_show_field 'creator_token', :label => 'Creator', :helper_method => 'link_for_my_local_tokens'
    config.add_show_field 'contributor_token', :label => 'Contributor', :helper_method => 'link_for_my_local_tokens'
    config.add_show_field 'created_token', :label => 'Created', :helper_method => 'link_for_my_local_tokens'
    config.add_show_field 'contributed_token', :label => 'Contributed to', :helper_method => 'link_for_my_local_tokens'
    config.add_show_field 'worldcat_id_token', :label => 'WorldCat ID', :helper_method => 'simple_link'
    config.add_show_field 'same_as_token', :label => 'Additional ID', :helper_method => 'simple_link'
    config.add_show_field 'identifier_token', :label => 'Identifiers', :helper_method => 'show_identifiers'
    config.add_show_field 'publisher_t', :label => 'Publisher', :helper_method => 'show_publishers'
    config.add_show_field 'holding_t', :label => 'Holding'
    config.add_show_field 'extent_t', :label => 'Extent'
    config.add_show_field 'dimensions_t', :label => 'Dimensions'
    config.add_show_field 'illustration_note_t', :label => 'Illustration note'
    config.add_show_field 'supplementary_content_note_t', :label => 'Supplementary content note'
    config.add_show_field 'birthdate_t', :label => 'Date of birth'
    config.add_show_field 'related_works_token', :label => 'Related works', :helper_method => 'show_related_works'
    config.add_show_field 'uri_token', :label => 'RDF linked data', :helper_method => 'show_rdf_link'

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
    
    config.add_search_field 'text', :label => 'Text'
    

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields. 
    
    config.add_search_field('title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params. 
      field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = { 
        :qf => '$title_qf',
        :pf => '$title_pf'
      }
    end
    
    config.add_search_field('author') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
      field.solr_local_parameters = { 
        :qf => '$author_qf',
        :pf => '$author_pf'
      }
    end
    
    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as 
    # config[:default_solr_parameters][:qt], so isn't actually neccesary. 
    config.add_search_field('subject') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
      field.qt = 'search'
      field.solr_local_parameters = { 
        :qf => '$subject_qf',
        :pf => '$subject_pf'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, pub_date_sort desc, title_sort asc', :label => 'relevance'
    config.add_sort_field 'pub_date_sort desc, title_sort asc', :label => 'year'
    config.add_sort_field 'author_sort asc, title_sort asc', :label => 'author'
    config.add_sort_field 'title_sort asc, pub_date_sort desc', :label => 'title'

    # If there are more than this many search results, no spelling ("did you 
    # mean") suggestion is offered.
    config.spell_max = 5
  end

end 

module ApplicationHelper
  
  def link_for_my_local_tokens(options)
    values = options[:value]
    values = [values] unless Array === values
    values = removeAlternates(values)
    html_array = values.map do |value|
      parse_json(value, 'id', 'label') do |v| 
        '<a href="%s">%s</a>' % [url_for_document(v['id']), v['label']]
      end
    end
    format_html_array(html_array)
  end
  
  def multiline_helper(options)
    format_html_array(options[:value])
  end

  def show_publishers(options)
    publishers = Set.new
    data = Array.new
    index = 0
    html_array = options[:value].map do |value|
      value = value.strip
      if not publishers.include?(value)
        data[index] = value
        index += 1
        publishers.add(value)
      end
    end
    format_html_array(data)
  end

  def simple_link(options)
    values = options[:value]
    values = [values] unless Array === values
    html_array = values.map do |value|
        slash_index = value.rindex('/')
        identifier = value.to_s[slash_index+1, value.size].strip
        identifier + ' <a href="'+value+'" target="_blank"><img border="0" src="/assets/infoIcon.png" height="18" ></a>'
	end
	  format_html_array(html_array)
  end

  def show_subjects(options)
    options = removeDuplicates(options[:value])
    html_array = options.map do |value|
      parse_json(value) do |v|
        type = v['type']
        if (isExternalLink(v['uri']))
          '%s <a href="%s" target="_blank"><img border="0" src="/assets/infoIcon.png" height="18" ></a>' % [v['label'], url_for_document(v['uri'])]
        elsif type['person'] || type['organization']
          '<a href="%s">%s</a>' % [url_for_document(v['id']), v['label']] 
        else
          v['label']
        end
      end
    end
    format_html_array(html_array)
  end
  
  def show_identifiers(options)
    html_array = options[:value].map do |value|
      parse_json(value, 'label') do |v|
        label, localname = v.values_at('label', 'localname')
        case localname
        when nil
          label
        when 'Identifier'
          label
        when 'LocalILSIdentifier'
          '%s (%s) <a href="https://newcatalog.library.cornell.edu/catalog/%s" target="_blank"><img border="0" src="/assets/infoIcon.png" height="18" ></a>'% [label, localname, label]
        when 'Lccn'
          slash_index = label.rindex('/L')
          lccn_Identifier = label[0, slash_index].strip
          '%s (%s) <a href="https://lccn.loc.gov/%s" target="_blank"><img border="0" src="/assets/infoIcon.png" height="18" ></a>'% [label, localname, lccn_Identifier]
        else
          label + " (#{localname})"
        end
      end
    end
    format_html_array(html_array)
  end
  
  def show_instances(options)
    values = options[:value]
    values = [values] unless Array === values
    html_array = values.map do |value|
      parse_json(value, 'id', 'label') do |v|
        if v['extent'] 
          '<a href="%s">%s</a>' % [url_for_document(v['id']), v['label']] + ' - (Extent: ' + v['extent']+')'
        else
          '<a href="%s">%s</a>' % [url_for_document(v['id']), v['label']]
        end
      end
    end
    format_html_array(html_array)
  end
  
  def show_rdf_link(options)
    ('<a href="%s">%s</a>' % [options[:value], options[:value]]).html_safe
  end

  def show_related_works(options)
    values = options[:value]
    values = [values] unless Array === values
    jsons = values.map {|v| parse_json(v) {|v| v}}.sort {|a,b| a['property'] <=> b['property']}
    html_array = jsons.map do |json|
      prop = uri_localname(json['property'])
      if json['id']
        '%s ==> <a href="%s">%s</a>' % [prop, url_for_document(json['id']), json['label']]
      else
        '%s ==> <a href="%s">%s</a>' % [prop, uri, json['label']]
      end
    end
    format_html_array(html_array)
  end

  #
  # Parse a JSON-formatted string, and provide it to the supplied block. The
  # return value is the value of the block.
  #
  # If the string is not valid JSON, write a message to the log and return the
  # original string.
  #
  # If a list of required keys are provided, then the parsed JSON object must
  # contain all of these keys, or is considered an error. Again, a message is
  # written to the log, and the original string is returned.
  #
  def parse_json(value, *required_keys)
    begin
      json = JSON.parse(value)
      if required_keys.any? {|k| !json[k]}
        puts "JSON is missing required fields: %s, required: %s" % [value, required_keys.inspect] 
        value
      else
        yield json
      end
    rescue
      puts "JSON PROBLEM " + $!.to_s
      puts $!.backtrace.join("\n")
      puts "VALUE IS " + value
      value
    end
  end
  
  #
  # Take an array of HTML values, and insert <br> between them. If more than 5 values,
  # wrap them in a scrolling div. Make the whole thing html_safe, and return it.
  #
  SCROLLING_DIV_BEGIN = '<div style="width:300px;height:110px;border:1px solid #ccc;line-height:1.5em;overflow:auto;padding:5px;">'
  SCROLLING_DIV_END = '</div>'
  def format_html_array(html_array)
    html_str = html_array.join('<br>')
    if html_array.size > 5
      html_str = SCROLLING_DIV_BEGIN + html_str + SCROLLING_DIV_END
    end
    html_str.html_safe
  end

  def uri_localname(uri)
    delimiter = uri.rindex(/[\/#]/)
    if delimiter
      uri[delimiter+1..-1]
    else
      uri
    end
  end

  def removeDuplicates(array)
    labels = Set.new
    options = Array.new
    index = 0
    array.map do |value|
      json = JSON.parse(value)
      label = json['label'].strip
      type = json['type']
      if labels.include?(label)
        label_index = getIndexBasedOnLabel(options, label)
        data = options[label_index]
        json1 = JSON.parse(data)
        options.delete(data) unless isExternalLink(json1['uri'])
        if isExternalLink(json['uri'])
          options[index] = value
          index = index+1
        end
      else
        labels.add(label)
        options[index] = value
        index = index+1
      end   
    end
    result = Set.new
    options.map do |value|
      if value
        result.add(value)
      end
    end
    result
  end

  def getIndexBasedOnLabel(options, label)
    options.each_with_index {|value, index|
      json = JSON.parse(value)
      if json['label'] === label
        return index
      end
    }
  end

  def isExternalLink(uri)
    return uri['http://id.']
  end

  def removeAlternates(values)
    uriSet = Set.new
    options = Array.new
    index = 0
    values.map do |value|
      json = JSON.parse(value)
      uri = json['uri'].strip
      if not uriSet.include?(uri)
        options[index] = value
        uriSet.add(uri)
        index += 1
      end
    end
    options
  end

end
