#- @title A demonstration of sword
#- @description
#- A test flow


#- @name setup_packages
#- @type setup
#- @flow first

#- @name test_load
#- @relies setup_packages
#- @type load_file

#- @name test_process
#- @type process
#- @uses test_clean


#- @name test_clean
#- @type process
#- @uses test_load


#- @name branch_1
#- @type process
#- @uses test_process


#- @name branch_2
#- @type process
#- @uses test_process



#- @name join
#- @type process
#- @uses branch_1 branch_2

#- @name save
#- @type save
#- @uses join



# testing second flow

#- @name setup_2
#- @type setup
#- @flow second


#- @name load_2
#- @type load
#- @relies setup_2

#- @name process_2
#- @type process
#- @uses load_2

#- @name save_2
#- @type save_db
#- @uses process_2
