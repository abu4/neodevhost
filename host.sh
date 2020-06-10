#!bin/bash
echo " "
echo "Clean..."
if [ -f host ]; then
    rm host
fi
if [ -f whitelist ]; then 
    rm whitelist
fi
if [ -f combine ]; then 
    rm combine
fi
if [ -f adblocker ]; then 
    rm adblocker
fi
if [ -f adblockercombine ]; then 
    rm adblockercombine
fi
if [ -f adblockerwhite ]; then 
    rm adblockerwhite
fi
if [ -f domaincombine ]; then 
    rm domaincombine
fi
if [ -f domain ]; then 
    rm domain
fi
if [ -f hosts_dnsmasq.conf ]; then 
    rm hosts_dnsmasq.conf
fi
if [ -f combinehosts_dnsmasq.conf ]; then 
    rm combinehosts_dnsmasq.conf
fi

echo " "
echo "Merge Whitelist..."
for url in `cat white` ;do
    wget --no-check-certificate -t 1 -T 10 -O tmp $url
    cat tmp >> tmpwhitelist
    rm tmp
done
sed -i '/#/d' tmpwhitelist
sed -i '/！/d' tmpwhitelist
sed -i 's/127.0.0.1 //' tmpwhitelist
sed -i 's/https:\/\///' tmpwhitelist
sed -i 's/http:\/\///' tmpwhitelist
sed -i 's/pp助手淘宝登录授权拉起//' tmpwhitelist
sed -i 's/只要有这一条，//' tmpwhitelist
sed -i 's/，腾讯视频网页下一集按钮灰色，也不能选集播放//' tmpwhitelist
sed -i 's/会导致腾讯动漫安卓版的逗比商城白屏//' tmpwhitelist
sed -i '/address/d' tmpwhitelist
sed -i '/REG ^/d' tmpwhitelist
sed -i '/RZD/d' tmpwhitelist
sed -i 's/ALL ./ /g' tmpwhitelist
sed -i 's/^[ \t]*//;s/[ \t]*$//' tmpwhitelist
sed -i '/^$/d' tmpwhitelist
sort -u tmpwhitelist > whitelist
rm tmpwhitelist

echo " "
echo "Merge ADlist..."
for url in `cat black` ;do
    wget --no-check-certificate -t 1 -T 10 -O tmp $url
    cat tmp >> tmphost 
    rm tmp
done
sed -i '/]/d' tmphost
sed -i '/:/d' tmphost
sed -i '/#/d' tmphost
sed -i '/ɢ/d' tmphost
sed -i '/255.255.255.255/d' tmphost
sed -i '/192.30.255.112/d' tmphost
sed -i '/151.101.56.133/d' tmphost
sed -i '/ip6-/d' tmphost
sed -i '/local/d' tmphost 
sed -i 's/127.0.0.1 //' tmphost
sed -i 's/0.0.0.0.//' tmphost
sed -i 's/0.0.0.0//' tmphost
sed -i 's/:443//' tmphost
sed -i 's/。//' tmphost
sed -i 's/^\.//' tmphost
sed -i 's/^[ \t]*//;s/[ \t]*$//' tmphost
sed -i '/^\s*$/d' tmphost
sed -i '1,3d'　tmphost
sort -u tmphost > host
rm tmphost

echo " "
echo "Merge Combine..."
sort -n host whitelist whitelist | uniq -u > tmp && mv tmp tmpcombine
sort -u tmpcombine > combine
rm tmpcombine


echo " "
echo "Adding Compatibility..."
cp host domain
cp host adblocker
cp combine domaincombine
cp combine adblockercombine
cp whitelist adblockerwhite
cp host hosts_dnsmasq.conf
cp combine combinehosts_dnsmasq.conf

sed -i 's/^/||&/' adblocker
sed -i 's/$/&^/' adblocker 

sed -i 's/^/@@||&/' adblockerwhite 
sed -i 's/$/&^/' adblockerwhite 

sed -i 's/^/||&/' adblockercombine
sed -i 's/$/&^/' adblockercombine 

sed -i 's/^/0.0.0.0  &/' host
sed -i 's/^/0.0.0.0  &/' combine

sed -i 's/^/address=\/&/' hosts_dnsmasq.conf 
sed -i 's/^/address=\/&/' combinehosts_dnsmasq.conf

sed -i 's/$/&\/0.0.0.0/' hosts_dnsmasq.conf  
sed -i 's/$/&\/0.0.0.0/' combinehosts_dnsmasq.conf 


echo " "
echo "Adding Title and SYNC data..."
sed -i '14cTotal ad / tracking block list 屏蔽追踪广告总数: '$(wc -l host)' ' README.md  
sed -i '16cTotal whitelist list 白名单总数: '$(wc -l whitelist)' ' README.md 
sed -i '18cTotal combine list 结合总数： '$(wc -l combine)' ' README.md
sed -i '20cUpdate 更新时间: '$(date "+%Y-%m-%d")'' README.md
cp title title.1
sed -i '9c# Last update: '$(date "+%Y-%m-%d")'' title.1
sed -i '11c# Number of blocked domains:  '$(wc -l host)' ' title.1   
cp title title.2
sed -i '9c# Last update: '$(date "+%Y-%m-%d")'' title.2
sed -i '11c# Number of blocked domains:  '$(wc -l combine)' ' title.2   
cp title title.3
sed -i '9c# Last update: '$(date "+%Y-%m-%d")'' title.3
sed -i '11c# Number of blocked domains:  '$(wc -l adblocker)' ' title.3
cp title title.4
sed -i '9c# Last update: '$(date "+%Y-%m-%d")'' title.4
sed -i '11c# Number of blocked domains:  '$(wc -l adblockercombine)' ' title.4   
cp title title.5
sed -i '9c# Last update: '$(date "+%Y-%m-%d")'' title.5
sed -i '11c# Number of blocked domains:  '$(wc -l hosts_dnsmasq.conf)' ' title.5
cp title title.6
sed -i '9c# Last update: '$(date "+%Y-%m-%d")'' title.6
sed -i '11c# Number of blocked domains:  '$(wc -l combinehosts_dnsmasq.conf)' ' title.6       

cat host >>title.1
cat combine >>title.2
cat adblocker >>title.3
cat adblockercombine >>title.4
cat hosts_dnsmasq.conf >>title.5
cat combinehosts_dnsmasq.conf >>title.6
rm host
rm combine
mv title.1 host
mv title.2 combine
mv title.3 adblocker
mv title.4 adblockercombine
mv title.5 hosts_dnsmasq.conf
mv title.6 combinehosts_dnsmasq.conf

echo " "
echo "Done!"
