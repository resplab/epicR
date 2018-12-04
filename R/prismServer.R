#' @export
gateway_json<-function(func,...)
{
  f<-get(func)
  out<-f(...)

  return(jsonlite::toJSON(out))
}

#' @export
gateway_json0<-function(func)
{

  f<-get(func)
  out<-f()

  return(jsonlite::toJSON(out))
}

#' @export
gateway_json1<-function(func,parms1)
{
  #code<-parse(text=paste(func,"(",parms,")"))
  #out<-eval(code)

  f<-get(func)
  out<-f(parms1)

  return(jsonlite::toJSON(out))
}

#' @export
gateway_json2<-function(func,parms1,parms2)
{
  f<-get(func)
  out<-f(parms1,parms2)

  return(jsonlite::toJSON(out))
}


#' @export
gateway_json3<-function(func,parms1,parms2,parms3)
{
  f<-get(func)
  out<-f(parms1,parms2,parms3)

  return(jsonlite::toJSON(out))
}







#' @export
gateway_json0_s<-function(session,func)
{
  session<<-session
  restore_session(session)
  f<-get(func)
  out<-f()
  save_session(session)
  return(jsonlite::toJSON(out))
}

#' @export
gateway_json1_s<-function(session,func,parms1)
{
  session<<-session
  restore_session(session)
  f<-get(func)
  out<-f(parms1)
  save_session(session)
  return(jsonlite::toJSON(out))
}

#' @export
gateway_json2_s<-function(session,func,parms1,parms2)
{
  session<<-session
  restore_session(session)
  f<-get(func)
  out<-f(parms1,parms2)
  save_session(session)
  return(jsonlite::toJSON(out))
}


#' @export
gateway_json3_s<-function(session,func,parms1,parms2,parms3)
{
  session<<-session
  restore_session(session)
  f<-get(func)
  out<-f(parms1,parms2,parms3)
  save_session(session)
  return(jsonlite::toJSON(out))
}










save_session<-function(session)
{
  rredis::redisConnect()
  e<-new.env()
  for(nm in names(globalenv()))
  {
    if(typeof(globalenv()[[nm]])!='closure')
    {
      e[[nm]]<-globalenv()[[nm]]
    }
  }
  rredis::redisSet(session,e)
}


restore_session<-function(session)
{
  rredis::redisConnect()
  e<-rredis::redisGet(session)
  for(nm in names(e))
  {
    if(typeof(e[[nm]])!='closure')
    {
      .GlobalEnv[[nm]]<-e[[nm]]
    }
  }
}






connect<-function(model_name,settings)
{
  session<-paste(c("a",sample(c(letters,LETTERS,paste(0:9)),15)),collapse="")
  return(session)
}








#' @export
get_default_input<-function()
{
  return(init_input()$values)
}




#' @export
model_run<-function(input)
{
  init_session()
  run(input = input)
  out<-Cget_output()
  terminate_session()
  return(out)
}




#' @export
get_output_structure<-function()
{
  out<-list(
    n_agents=prism_output(source="$n_agents", type = "numeric/scalar", group = "", title = "Number of simulated individuals", description = ""),
    cumul_time=prism_output(source="$cumul_time",type = "numeric/scalar", title = "cumulative time"),
    n_deaths=prism_output(source="$n_deaths",type = "numeric/scalar", title = "number of deaths"),
    n_COPD=prism_output(source="$n_COPD",type = "numeric/scalar", title = "Number of patients with COPD"),
    total_exac=prism_output(source="$total_exac",type = "numeric/vector", title = "Total number of exacerbations by severity"),
    total_exac_time=prism_output(source="$total_exac_time",type = "numeric/vector", title = "total_exac_time"),
    total_pack_years=prism_output(source="$total_pack_years",type = "numeric/scalar", title = "Total pack-years"),
    total_doctor_visit=prism_output(source="$total_doctor_visit",type = "numeric/vector", title = "Total doctor visits"),
    total_cost=prism_output(source="$total_cost",type = "numeric/scalar", title = "Total costs"),
    total_qaly=prism_output(source="$total_qaly",type = "numeric/scalar", title = "Total QALY")
  )
  return(out)
}



####################Redis example

set_redis<-function(variable,value)
{
  rredis::redisConnect()
  rredis::redisSet(variable,value)
  return(0)
}


get_redis<-function(variable)
{
  rredis::redisConnect()
  x<-rredis::redisGet(variable)
  return(x)
}





set_var<-function(variable,value)
{
  .GlobalEnv[[variable]]<-value
}


get_var<-function(variable)
{
  return(.GlobalEnv[[variable]])
}





























###################Prism objects#################
#Version 2018.11.04

prism_input_types<-c("numeric/scalar","numeric/vector","numeric/matrix","string/scalar","string/vector","string/matrix","file/csv")

#' @export
prism_input <- function(value, type="", group="", default=NULL, range=c(NULL,NULL), title="", description="", control="")
{
  me <- list(
    value=value,
    type = type,
    default = default,
    range=range,
    title=title,
    description=description,
    control=control
  )

  if(type=="")  me$type<-guess_prism_input_type(me)

  ## Set the name for the class
  class(me) <- append(class(me),"prism_input")
  return(me)
}



guess_prism_input_type<-function(p_inp)
{
  if(is.numeric(p_inp$value)) type="numeric" else type="string"
  if(is.vector(p_inp$value)) {if(length(p_inp$value)<=1) type<-paste(type,"/scalar",sep="") else type<-paste(type,"/vector",sep="")}
  if(is.matrix(p_inp$value)) {type<-paste(type,"/matrix",sep="")}
  return(type)
}







print <- function(x)
{
  UseMethod("print",x)
}
print.prism_input<-function(x)
{
  print.listof(x)
}



Ops<-function(e1,e2)
{
  UseMethod("Ops",x)
}
Ops.prism_input<-function(e1,e2)
{
  source<-NULL;
  dest<-NULL;
  if(sum(class(e1)=="prism_input")>0) {source<-e1; e1<-e1$value}
  if(sum(class(e2)=="prism_input")>0) {dest<-e2; e2<-e2$value}
  val<-NextMethod(.Generic)
  if(is.null(source)) return(val) else {source$value<-val; return(source)}
}


Math<-function(x,...)
{
  UseMethod("Math",x,...)
}
Math.prism_input<-function(x,...)
{
  source<-NULL;
  dest<-NULL;
  if(sum(class(x)=="prism_input")>0) {source<-x; x<-x$value}
  val<-NextMethod(.Generic)
  if(is.null(source)) return(val) else {source$value<-val; return(source)}
}



Summary<-function(...,na.rm)
{
  UseMethod("Summary",...,na.rm)
}

#' @export
Summary.prism_input<-function(...,na.rm)
{
  message("hi")
  args<-list(...)
  args <- lapply(args, function(x) {
    if(sum(class(x)=="prism_input")>0) x$value
  })
  do.call(.Generic, c(args, na.rm = na.rm))
}



#' @export
canbe_prism_input<-function(...)
{
  y<-prism_input(0)
  xn<-sort(names(...))
  yn<-sort(names(y))
  if(length(xn)==length(yn) && sum(xn==yn)==length(xn)) return(T) else return(F)
}


#' @export
to_prism_input<-function(x)
{
  if(is.list(x))
  {
    out<-prism_input(value=x$value)
    for(nm in names(out))
      if(!is.null(x[nm])) out[nm]<-x[nm]
      return(out)
  }
  return(prism_input(x))
}















prism_output_types<-c("numeric/scalar","numeric/vector","numeric/matrix","string/scalar","string/vector","string/matrix","file/csv","graphic/url","graphic/data")
#' @export
prism_output <- function(title="", type="numeric", source="", group="", value=NULL, description="")
{
  me <- list(
    type = type,
    source = source,
    group=group,
    value=value,
    title=title,
    description=description
  )

  ## Set the name for the class
  class(me) <- append(class(me),"prism_output")
  return(me)
}





#' @export
as.prism_output<-function(...)
{
  x<-list(...)[[1]]
  out<-prism_output()
  for(i in 1:length(x))
  {
    if(length(x[[i]])>0) out[names(x)[i]]<-x[[i]]
  }
  return(out)
}

#' @export
canbe_prism_output<-function(...)
{
  y<-prism_output()
  xn<-sort(names(...))
  yn<-sort(names(y))
  if(length(xn)==length(yn) && sum(xn==yn)==length(xn)) return(T) else return(F)
}

#' @export
to_prism_output<-function(x)
{
  if(is.list(x))
  {
    out<-prism_output()
    for(nm in names(out))
      if(!is.null(x[nm])) out[nm]<-x[nm]
      return(out)
  }
  return(prism_output(x))
}




#' @export
print.prism_output<-function(x)
{
  if(length(x$value)>100) x$value=paste("[Data of length",length(x$value),"]")
  dput(unclass(x))
}






