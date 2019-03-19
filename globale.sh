change_to_build()
{
	mkdir -v build
	cd       build
}

make_both()
{
	make
	make install
}

unit_test1()
{
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools'
rm -v dummy.c a.out
}
