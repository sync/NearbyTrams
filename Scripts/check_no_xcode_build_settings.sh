#!/bin/sh
#
# Check that there are no overridden build settings in Xcode
# This is hacky, if I could work out how to parse the project file I'd do it better
# - SG

for PROJECT in $*; do
	
	PROJECT_FILE_PATH=$PROJECT/project.pbxproj

	NUMBER_OF_BUILD_SETTINGS=`grep "buildSettings" $PROJECT_FILE_PATH | wc -l`
	NUMBER_OF_EMPTY_BUILD_SETTINGS=`grep -B 0 -A 1 "buildSettings" $PROJECT_FILE_PATH | grep "};" | wc -l`

	if [ $NUMBER_OF_BUILD_SETTINGS != $NUMBER_OF_EMPTY_BUILD_SETTINGS ]; then
	  NUMBER_WITH_SETTINGS=`expr $NUMBER_OF_BUILD_SETTINGS - $NUMBER_OF_EMPTY_BUILD_SETTINGS`
  
	  echo "FAIL:"
	  echo "\ttsk tsk... Do you not look at your project file diffs before committing?\n"
	  echo "\tSome targets have build settings overridden in the Xcode project file"
	  echo "\tThis should be done in the xcconfig files as the single source of truth\n"
	  echo
	  echo "DETAILS:"
	  echo "\tProject file: $PROJECT_FILE_PATH"
	  echo "\tThere are $NUMBER_OF_BUILD_SETTINGS sets of build settings, $NUMBER_WITH_SETTINGS are non-empty"
	  echo "\t(most likely, you dragged in libraries/frameworks/files and Xcode tried to help you)"
  
	  exit 1
	fi

done

