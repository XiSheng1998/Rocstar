set(METIS_SOURCES coarsen.c fm.c initpart.c match.c ccgraph.c memory.c 
       pmetis.c pqueue.c refine.c util.c timing.c debug.c 
       bucketsort.c graph.c stat.c kmetis.c kwayrefine.c 
       kwayfm.c balance.c ometis.c srefine.c sfm.c separator.c 
       mincover.c mmd.c mesh.c meshpart.c frename.c fortran.c 
       myqsort.c compress.c parmetis.c estmem.c 
       mpmetis.c mcoarsen.c mmatch.c minitpart.c mbalance.c 
       mrefine.c mutil.c mfm.c mkmetis.c mkwayrefine.c mkwayfmh.c 
       mrefine2.c minitpart2.c mbalance2.c mfm2.c 
       kvmetis.c kwayvolrefine.c kwayvolfm.c subdomains.c)
	   
add_library(metis ${METIS_SOURCES})
target_include_directories(metis PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
set_property(TARGET metis PROPERTY VERSION 4.0.3)
target_link_libraries(metis libm)

install_libraries(metis)