# Docker for SlicerSALT

## Usage

```sh
docker pull noshita/slicersalt:latest
```


```sh
# GenParaMesh
docker run -v XXX:YYY noshita/slicersalt GenParaMeshCLP 

# ParaToSPHARMMesh
docker run -v XXX:YYY noshita/slicersalt ParaToSPHARMMeshCLP 
```

`XXX`はホスト側の解析対象と出力先を含むディレクトリの絶対パス．もし入力と出力先が離れている場合は複数オプションを指定してマウントすればよい．
`YYY`はコンテナ側のマント先のディレクトリの絶対パス．

ディレクトリはデフォルトでは`read-write mode`でマウントされる．

## Build, publish

```sh
docker build ./ -t noshita/slicersalt:latest
```

```sh
docker login
docker push noshita/slicersalt:latest
```