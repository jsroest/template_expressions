
pushd ..;
rm -r ./coverage
dart pub global run coverage:test_with_coverage
genhtml coverage/lcov.info -o coverage/html
popd;