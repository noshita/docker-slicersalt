# Docker for SlicerSALT

## Usage

```sh
docker pull noshita/slicersalt:latest
```

### GenParaMesh

```sh
docker run -v XXX:YYY --rm noshita/slicersalt GenParaMeshCLP -- INPUT_VOLUME OUTPUT_PARA_MESH OUTPUT_SURFACE_MASH
```

* `XXX`: ホスト側の解析対象と出力先を含むディレクトリの絶対パス．もし入力と出力先が離れている場合は複数オプションを指定してマウントする．
* `YYY`: コンテナ側のマウント先のディレクトリの絶対パス．
* `INPUT_VOLUME`: 入力するボリュームファイル（nrrd）
* `OUTPUT_PARA_MESH`: 計算されたパラメータメッシュ（vtk）
* `OUTPUT_SURFACE_MASH`: 計算された表面メッシュ（vtk）

ディレクトリはデフォルトでは`read-write mode`でマウントされる．

GNU parallelなどにより並列実行することも可能．

```sh
INPUT_FILES=($(ls $INPUT_DIR/*.nrrd))

parallel -j $N_JOB "docker run -v XXX:YYY --rm noshita/slicersalt GenParaMeshCLP --iter $N_ITER -- GenParaMeshCLP -- $INPUT_DIR/{1} $OUTPUT_DIR/{1.}_para.vtk $OUTPUT_DIR/{1.}_surf.vtk" ::: ${INPUT_FILES[@]}
```

* `INPUT_DIR`: 入力するボリュームデータが保存されているディレクトリ
* `OUTPUT_DIR`: 出力先のディレクトリ
* `N_JOB`: 並列実行するジョブ数．
* `N_ITER`: GenParaMeshでのiteration数 


`if-then-else`により，すでに処理済みのものをスキップすることも可能．

```sh
parallel -j $N_JOB --progress "if [ -e $OUTPUT_DIR/{1.}_para.vtk ]; then echo skip: $INPUT_DIR/{1}; else docker run -v XXX:YYY noshita/slicersalt GenParaMeshCLP --iter $N_ITER -- $INPUT_DIR/{1} $OUTPUT_DIR/{1.}_para.vtk $OUTPUT_DIR/{1.}_surf.vtk; fi" ::: ${INPUT_FILES[@]}
```

### ParaToSPHARMMesh

```sh
docker run -v XXX:YYY --rm noshita/slicersalt ParaToSPHARMMeshCLP --spharmDegree $SPHARM_DEGREE --subdivLevel $SUBDIV_LEVEL -- INPUT_PARA_MESH INPUT_SURFACE_MESH OUTPUT_DIRECTORY_BASENAME
```
* `INPUT_PARA_MESH`, `INPUT_SURFACE_MESH`: GenParaMeshの出力結果．
* `OUTPUT_DIRECTORY_BASENAME`: 出力先のディレクトリと出力ファイル名（ベース部分）をつなげたもの
  * 例：`$HOME/output_parameter_to_spharm/example`．この場合はディレクトリ`$HOME/output_parameter_to_spharm`に`example_XXX`という名前の出力が（複数）出力される．
* `SPHARM_DEGREE`: 球面調和関数解析で利用する次数
* `SUBDIV_LEVEL`: 表面の分割レベル

並列化などは上記のGenParaMeshと同様．

## Build, publish

```sh
docker build ./ -t noshita/slicersalt:latest
```

```sh
docker login
docker push noshita/slicersalt:latest
```


## License
Licensed under the Apache License, Version2.0.