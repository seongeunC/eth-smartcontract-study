# eth-smartcontract-study

## 이더리움 private network 구축 & dapp 개발 셋팅
1. virtualBox 설치 
2. 광학드라이브 ubuntu iso 파일 삽입
3. linux 실행

----

#### 1. 터미널 실행 

이더리움 셋팅
```
$sudo apt-get -y update && sudo apt-get -y upgrade
$sudo apt-get install nodejs
$sudo apt install aptitude$sudo aptitude install npm
$sudo apt-get install software-properties-common$sudo add-apt-repository -y ppa:ethereum/ethereum
$sudo add-apt-repository -y ppa:ethereum/ethereum-dev
//참고 <https://247cryptonews.com/how-to-install-latest-ethereum-node-on-ubuntu-16-04/>

$sudo apt-get update$sudo apt-get install ethereum
$geth version  //geth 설치가 잘 되었는 지 확인//putty 연결을 위해 ssh설치
$sudo -s   
$sudo apt-get install ssh$sudo apt-get install openssh-server
```
###### 스냅샷을 찍음! -> 나중에 계속해서 위 코드를 진행하지 않도록!

------------------------------------스냅샷 복원 , 저장된 상태 삭제 -----------------------------------------------------

1. 설정 -> 네트워크 -> 어댑터 추가(브리지 어댑터) -> 가상머신 시작
2. putty 실행

##### 1번 putty 터미널
```
$sudo ifconfig enp0s8 192.168.0.x netmask 255.255.255.0 up    ( x == host 컴퓨터에 ip에서 100더하기)
$sudo route add default gw 192.168.0.1
$mkdir contract_testnet
$cd contract_testnet
-----contract_testnet 작업디렉토리 변경----------
&vi genesis.json   (제네시스 정보 입력)
$geth --datadir ~/contract_testnet/ init ~/contract_testnet/genesis.json
$nohup geth --networkid 4689 --nodiscover --datadir ~/test --rpc --rpcaddr "192.168.0.210" --rpcport 8545 --rpccorsdomain "*" --rpcapi "admin,db,eth,debug,miner,net,ssh,txpool,personal,web3" --verbosity 6 2>> ~/test/geth.log&
&ps -eaf | grep geth$tail -f geth.log
```

#### 2번 putty 터미널
```
$geth attach rpc:http://192.168.0.x:8545
주소계정 생성
>personal.newAccount("pass0")
"0x7a~ 9"
>personal.newAccount("pass1")
"0x5f~ 5"
무기한 계정 잠금해제
>personal.unlockAccount(eth.accounts[], "pass0", 0)
잔액>
eth.getBalance(eth.accounts[0])
0
>eth.getBalance(Eth.accounts[1])
0
블록 개수
>eth.blockNumber
0
채굴자 확인
>eth.coinbase"0x7a~ 9"
채굴 시작
>miner.start()
null
채굴 정지
>miner.stop()
true
Wei를 Ether로 변환
>web3.fromWei(eth.getBalance(eth.accounts[0]),"ether")
302
```

---------------------------remix와 geth 연동 & SmartContract 작성 & Private network에 배포-------------------------------
	1. remix 실행
	2. setting -> solidity version 선택 
	3. run -> web3provider  선택 -> [http://192.168.0.x:8545] 연결    ! {오류 시 url에서 s를 지우고 다시}


	1. SmartContract 작성  -> compile -> start to compile
	2. [2]번 putty터미널 창 실행
	3. personal.unlockAccount(eth.accounts[0])
	4. miner.start() 
	5. remix 창 -> run -> deploy

-------------------------------------------------웹 서비스를 통한 dapp 구현 ----------------------------------------------
#### 1번 putty 실행

#### 3번 putty 터미널
```
$sudo npm install express-generator -g
$sudo ln -s /usr/bin/nodejs /usr/local/bin/node$express web3
$cd web3$npm install$DEBUG=web3 npm start웹 브라우저에서 http://192.168.0.x로 접속
```
	1. WinSCP 설치
	2. 설치 후 로그인 창에서 호스트 이름과 포트번호 입력 (PUTTY 접속 할 때 동일)
	3. /home/[user]/web3/public 폴더에 html 파일 업로드
	4. /home/[user]/web3/public/javascripts 폴더에 web3.min.js 파일 업로드 -> 직접 web3.min.js파일을 다운로드 하지않아도 됨 CDN 기법을 사용!

-><script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js/dist/web3.min.js">
	1. 웹 브라우저에서 "192.168.0.x:3000/[html파일 명] 접속

----------------------------------------------------------------------Mist 설치 & private network 연동------------------------------------
	1. 미스트 설치(launch문구 뜨면 실행 )후 바로 종료
	2. cmd창 실행

>cd [Ethereum mist 설치 폴더]
>"Ethereum Wallet.exe" --rpc http://192.168.0.x:8545 
--------------peer 연결  "user1" , "user2" 가 잇다고 가정 -----------------------------
	1. "user1"과 "user2" 모두 1번 putty 터미널과 2번 putty터미널을 진행

//user1 터미널
>admin.nodeInfo.endoe"enode://c482ifnvmveu3~ ~ ~ @[::]:30303?discport = 0" ▶[::]부분에 user1번의 192.168.0.x를 대입하여 모두 복사//user2 터미널
>admin.addPeer("[위에서 복사한 enode 값]")
	1. 연결확인

>net.peerCount1
>admin.peers1

----------
#!/bin/sh
sudo ifconfig enp0s8 "$1" netmask 255.255.255.0 up
sudo route add default gw "$2"cd contract_testnetgeth --datadir ~/contract_testnet/ init ~/contract_testnet/genesis.json
nohup geth --networkid 4689 --nodiscover --datadir ~/contract_testnet --rpc --rpcaddr '"'"$1"'"' --rpcport 8545 --rpccorsdomain '"*"' --rpcapi '"admin,db,eth,debug,miner,net,shh,txpool,personal,web3"' --verbosity 6 2>> ~/contract_testnet/geth.log&
tail -f geth.log

---------
