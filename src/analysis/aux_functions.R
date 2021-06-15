paquetines <- c("readxl","magrittr","dplyr","ggplot2","tidyr","readr","stringr","fuzzyjoin","rstan","DBI","RPostgreSQL","rangeMapper","bnlearn","BiocManager","mapproj")
no_instalados <- paquetines[!(paquetines %in% installed.packages()[,"Package"])]
if(length(no_instalados)) install.packages(no_instalados)
BiocManager::install("Rgraphviz")
lapply(paquetines, library, character.only = TRUE)
library(Rgraphviz)


th <- theme_minimal()+
  theme(panel.grid.major.y = element_line(color = "gray"),
        text = element_text(color = "gray20"),
        axis.title.x = element_text(face="italic",size = 14),
        axis.title.y = element_text(face="italic",size = 14),
        axis.text = element_text(size=12),
        legend.direction = "vertical",
        legend.box = "vertical",
        legend.text = element_text(size = 14),
        legend.title = element_text(size = 14),
        plot.caption = element_text(hjust=0),
        plot.title = element_text(size = 16, face = "bold",hjust=0.39))

#' @title plan_connect
#'
#' @description This function takes the Postgres environment variables
#' to automatically connect to the planeadb database.
#' The connection must be saved into a variable in order to
#' use future functions. I'm cheating and not reading from .env.
#'
#' @examples con <- prev_connect()
#'
#' @param No parameter is needed.
#' @export
plan_connect <- function(){
  DBI::dbConnect(RPostgreSQL::PostgreSQL(),
  host     =  "localhost",
  user     =  "planea",
  password =  "planea",
  port     =  5432,
  dbname   =  "planea")
}

#' @title load_query
#'
#' @description Allows to run specific queries with the dbrsocial syntax.
#'
#' @param connection DBI connection. A connection to a database
#' @param schema variable. A valid schema from a database on the
#' @param the_table.  An existing table in the given schema.
#' @param colums string. The columns in the database we want to retrieve
#' information
#' @param options string. Part of the SQL query with containing WHERE, ORDER,
#' LIMIT and so statements
#'
#' @examples geom_muni <-
#' load_query(con,raw,sifode,columns="entidadfederativa",options="WHERE
#' mes='Abril'")
#' @export
load_query <- function(connection,schema,the_table,columns="*",options=""){
    the_query <- "SELECT %s FROM %s.%s"
    complete <- paste0(the_query," ",options)
    schema    <- deparse(substitute(schema))
    the_table <- deparse(substitute(the_table))
    initial <- RPostgreSQL::dbSendQuery(connection,
                             sprintf(complete,columns,schema,the_table))
    return(initial)
}

#' @title load_table
#'
#' @description This function loads a connection to
#' a given table from a particular schema in a database
#' connection.
#'
#' @param connection DBI connection. A connection to a database
#' must be open and given.
#' @param schema variable. A valid schema from a database on the
#' connected database.
#' @param the_table. An existing table in the given schema.
#'
#' @examples the_dic<-load_table(con,raw,sifode_dic)
#' @export
load_table <- function(connection,schema,the_table){
    the_query <- "SELECT * FROM %s.%s"
    schema    <- deparse(substitute(schema))
    the_table <- deparse(substitute(the_table))
    initial <- RPostgreSQL::dbSendQuery(connection,
                             sprintf(the_query,schema,the_table))
}

#' @title large_table
#'
#' @description This function loads a connection to a large table without
#' loading it to memory.
#'
#' @param connection DBI connection. A connection to a database
#' must be open and given.
#' @param schema variable. A valid schema from a database on the
#' connected database.
#' @param the_table. An existing table in the given schema.
#'
#' @examples cuis_table <- large_table(con,raw,cuis_39_9)
#' @export
large_table <- function(connection,schema,the_table){
    schema    <- deparse(substitute(schema))
    the_table <- deparse(substitute(the_table))
    retrieved <- dplyr::tbl(connection,dbplyr::in_schema(schema,the_table))
    return(retrieved)
}

#' @title clear_results
#'
#' @description This function clears the results from a previous executed
#' query.
#'
#' @param connection DBI connection. A connection to a database must be open and given.
#'
#' @examples clear_results(con)
#' @export
clear_results <- function(connection){
    DBI::dbClearResult(DBI::dbListResults(connection)[[1]])
}

#' @title join_tables
#'
#' @description Returns a match between two tbl by defined key
#' @param left_table a tbl-like object
#' @param right_table a tbl-like object
#' @param left_key the column name from left_table to compare
#' @param right_key the column name from right_table to compare
#'
#' @examples join_tables(cuis_sample,llave_hogar_h,domicilios_sample_query,llave_hogar_h)
#' @export
join_tables <- function(left_table, left_key, right_table, right_key){
    left_key <- substitute(left_key)
    right_key <- deparse(substitute(right_key))
    in_tables <- left_table %>%
        dplyr::filter(left_key %in% right_table[[right_key]])
    return(in_tables)
}

WKT2SpatialPolygonsDataFrame <- function(dat, geom, id) {
	dl = split(dat, dat[, id])

	o = lapply(dl, function(x) {

		p = mapply(rgeos::readWKT, text = x[, geom], id = 1:nrow(x), USE.NAMES = FALSE )
			if(length(p) == 1) {
				p = p[[1]]
				p = spChFIDs(p, as.character(x[1, id]))
				}

			if(length(p) > 1) {
				p = do.call(sp::rbind.SpatialPolygons, p)
				p = rgeos::gUnionCascaded(p, id = as.character(x[1, id]) )
				}
	p
	})

	X = do.call(sp::rbind.SpatialPolygons, o)
	dat = data.frame(id = sapply(slot(X, "polygons"), function(x) slot(x, "ID")) )
	row.names(dat ) = dat$id
	names(dat) = id
	X = sp::SpatialPolygonsDataFrame(X, data =  dat)
	X
	}

#' @title retrieve_result
#'
#' @description Return the fetch results of a query
#' @param query An exec unfetched query
#'
#' @examples sample_table(load_table(prev_connect(),raw,sifode))
#' @export
retrieve_result <- function(query,n=-1,number=Inf){
    if (class(query)[1] == "tbl_dbi"){
        the_table <- dplyr::collect(query,n=number)
        return(the_table)
    }
    else{
    the_table <- DBI::dbFetch(query,n)
    return(the_table)
    }
}

#' @title load_geom
#'
#' @description Gives a "ready to go" data frame for geometry plotting
#'
#' @param connection DBI connection. A connection to a database
#' @param schema variable. A valid schema from a database on the
#' @param the_table.  An existing table in the given schema.
#' @param colums string. The columns in the database we want to retrieve.
#' Defaults cve_ent, cve_mun, cve_muni.
#' @param geom_col . The name of the column in the database that contains a geometry
#' @param col_shape. The name of the column that we want to use to join
#' information
#' @param options string. Part of the SQL query with containing WHERE, ORDER,
#' LIMIT and so statements
#'
#' @examples geom_muni <- load_geom(con1,raw,geom_municipios,geom_col=geom,col_shape=cve_muni,options=options)
#' @export
load_geom <- function(connection,schema,the_table,columns="\"CVEGEO\", \"CVE_ENT\", \"CVE_MUN\"", geom_col, col_shape, options=""){
    geom_col <- deparse(substitute(geom_col))
    schema    <- deparse(substitute(schema))
    the_table <- deparse(substitute(the_table))
    col_shape <- deparse(substitute(col_shape))
    geom_col2 <- paste0("\"",geom_col,"\"")

    the_query <- "SELECT %s FROM %s.%s"
    geom_col_as <- sprintf(", %s as geom",geom_col2)
    columns <- paste0(columns,geom_col_as)
    complete <- paste0(the_query," ",options)

    initial <- RPostgreSQL::dbSendQuery(connection,
                             sprintf(complete,columns,schema,the_table)) %>%
    retrieve_result()

    mun_shp = WKT2SpatialPolygonsDataFrame(initial, geom = "geom", id = col_shape)
    # mun_shp = sp::SpatialPolygonsDataFrame(initial, geom = "geom", id = col_shape)
    mun_df <- fortify(mun_shp, region = col_shape)
    names(mun_df)[names(mun_df)=="id"] <- col_shape

    return(mun_df)
}

load_geom2 <- function(connection,schema,the_table,columns="\"CVEGEO\", \"CVE_ENT\", \"CVE_MUN\"", geom_col, col_shape, options=""){
    geom_col <- deparse(substitute(geom_col))
    schema    <- deparse(substitute(schema))
    the_table <- deparse(substitute(the_table))
    col_shape <- deparse(substitute(col_shape))
    geom_col2 <- paste0("\"",geom_col,"\"")

    the_query <- "SELECT %s FROM %s.%s"
    geom_col_as <- sprintf(", %s as geom",geom_col2)
    columns <- paste0(columns,geom_col_as)
    complete <- paste0(the_query," ",options)

    initial <- RPostgreSQL::dbSendQuery(connection,
                             sprintf(complete,columns,schema,the_table)) %>%
    retrieve_result()

    return(initial)
}

#' @title discon_db
#'
#' @description This function disconnects a PostgreSQL
#' connection.
#'
#' @param connection DBI connection. A connection to a database must be open and given.
#'
#' @examples discon_db(con)
#' @export
discon_db <- function(connection){
    RPostgreSQL::dbDisconnect(connection)
}
