module.exports = function(context) {
    console.log('Manualy add -DLINUX flag under cflags');
    console.log('Manualy add -fno-objc-arc flag Build phases => Compile Sources, for each file that doesnt use ARC');
    console.log('Set ENABLE_BITCODE to no');
}
