#!/bin/sh

OUTPUT_DIR_PATH="${PWD}/XCFrameworks"

function archive {
    echo "Archiving scheme: ${1} destination: ${2};\nArchive path: ${3}.xcarchive"
    xcodebuild clean archive \
    -project "SwiftGRPC-Carthage.xcodeproj" \
    -scheme ${1} \
    -destination "${2}" \
    -archivePath "${3}" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcpretty
}

function buildArchive {
  SCHEME=${1}
  ARCHIVE_PATH=${PWD}/.build/Framework/archives

  archive $SCHEME "generic/platform=iOS Simulator" "${ARCHIVE_PATH}/${SCHEME}-iOS-Simulator"
  archive $SCHEME "generic/platform=iOS" "${ARCHIVE_PATH}/${SCHEME}-iOS"
}

function createXCFramework {
  POSTFIX=".xcarchive/Products/Library/Frameworks"
  ARCHIVE_PATH=${PWD}/.build/Framework/archives

  xcodebuild -create-xcframework \
            -framework "${ARCHIVE_PATH}/${SCHEME}-iOS-Simulator${POSTFIX}/${1}.framework" \
            -framework "${ARCHIVE_PATH}/${SCHEME}-iOS${POSTFIX}/${1}.framework" \
            -output "${OUTPUT_DIR_PATH}/${1}.xcframework"
}

echo "#####################"
echo "Cleaning: ${OUTPUT_DIR_PATH}"
rm -rf $OUTPUT_DIR_PATH

FRAMEWORK="CgRPC"

echo "Archiving $FRAMEWORK"
buildArchive ${FRAMEWORK}

echo "Creating $FRAMEWORK.xcframework"
createXCFramework ${FRAMEWORK}