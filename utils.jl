using OrderedCollections, Franklin, DelimitedFiles

@delay function hfun_posts()
    io = IOBuffer()
    categories = filter!(p -> !(endswith(p, ".md")), readdir("posts/"))
    for (_, category) in enumerate(categories)
        write(io, "~~~<h3><a href=\"/posts/$category/\">$category</a></h3>~~~\n")
        category_dir = joinpath("posts", category)
        posts = filter!(p -> endswith(p, ".md"), readdir(category_dir))
        posts = filter!(p -> (!(startswith(p, "index"))), posts)
        lines = Vector{String}(undef, length(posts))
        for (i, post) in enumerate(posts)
            ps = splitext(post)[1]
            url = "/posts/$category/$ps/"
            surl = strip(url, '/')
            title = Franklin.pagevar(surl, :title)
            tmp = "~~~<span class=\"category-link\"></span><a href=\"$url\" class = \"category\">$title</a><br>"
            lines[i] = tmp * "~~~\n"
        end
        foreach(line -> write(io, line), lines)
    end
    return Franklin.fd2html(String(take!(io)), internal=true)
end

hfun_github() = """<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">  <title id="githubtitle">github repo link</title>
  <desc id="githubDesc">my github repo.</desc> <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/></svg>"""

function hfun_navigation()
    isempty(Franklin.PAGE_HEADERS) && return ""
    io = IOBuffer()
    key_title = 0
    md_titles = OrderedDict{Int64,Any}()
    write(io, "<div class=\"toc\">Table of Contents</div>")
    for (key, val) in Franklin.PAGE_HEADERS
        order = val[3]
        if order <= 2
            key_title += 1
            dict_one = OrderedCollections.OrderedDict()
            setindex!(dict_one, val, key)
            setindex!(md_titles, dict_one, key_title)
        elseif order == 3
            setindex!(md_titles[key_title], val, key)
        end
    end
    for i = 1:key_title
        key = first(md_titles[i])[1]
        val = first(md_titles[i])[2]
        write(io, "<li>")
        write(io, """<div class="nav__sub-title">""")
        write(io, """<a  href=\"#$key\">$(val[1])</a>""")
        write(io, """</div>""")
        order = 0
        order_base = first(md_titles[i])[2][3]
        for (key, val) in md_titles[i]
            if key != first(md_titles[i])[1]
                order = val[3]
                gap = order - order_base
                order_base = order
                if gap > 0
                    for i = 1:gap
                        println(io, "<ul>")
                    end
                end
                if gap < 0
                    for i = 1:-gap
                        println(io, "</ul>")
                    end
                end
                text = string("", val[1])
                println(io, """<li><a href=\"#$key\" class="active">$(text)</a></li>""")
            end
        end
        for i = 1:order-first(md_titles[i])[2][3]
            println(io, "</ul>")
        end
        write(io, "</li>\n")
    end

    return String(take!(io))
end

@delay function hfun_inner()
    current_path = Franklin.locvar(:fd_rpath)
    current_file = chopprefix(current_path, r".*/")
    current_file = chopsuffix(current_file, r".md")
    io = IOBuffer()
    write(io, "~~~<br>~~~\n")
    write(io, "~~~<div class=\"inner-link\"><div class=\"il-header\">inner link</div>~~~\n")
    dir = chopsuffix(current_path, r"/\w*.md$") * "/"
    posts = filter!(p -> ((endswith(p, ".md"))), readdir(dir))
    posts = filter!(p -> (!(startswith(p, "index"))), posts)
    for (_, post) in enumerate(posts)
        ps = splitext(post)[1]
        url = "$dir/$ps/"
        surl = rstrip(url, '/')
        title = Franklin.pagevar(surl, :title)
        descr = Franklin.pagevar(surl, :descr)
        if ps != current_file
            if current_file == "index"
                tmp = "~~~<a href=\"$ps\" class = \"category\">$title</a><br>"
            else
                tmp = "~~~<a href=\"../$ps/\" class = \"category\">$title</a><br>"
            end
            if descr !== nothing
                tmp *= "<span class=\"post-descr\">$descr</span><br>"
            end
            line = tmp * "~~~\n"
            write(io, line)
        end
    end
    write(io, "~~~</div>~~~\n")
    return Franklin.fd2html(String(take!(io)), internal=true)
end
