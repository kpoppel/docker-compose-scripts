#### dns_verify.sh
#
NETS="10.0.0"
IPS=$(seq 1 200)  ## for Linux
#
# IPS=$(jot 254 1)  ## for OpenBSD or FreeBSD
# IPS=$(seq 1 254)  ## for Linux 
#
echo
echo -e "\tip        ->     hostname      -> ip"
echo '--------------------------------------------------------'  

for NET in $NETS; do
  for n in $IPS; do
    A=${NET}.${n}
    HOST=$(dig -x $A +short)
    if test -n "$HOST"; then
      ADDR=$(dig $HOST +short)
      if test "$A" = "$ADDR"; then
        echo -e "ok\t$A -> $HOST -> $ADDR"
      elif test -n "$ADDR"; then
        echo -e "fail\t$A -> $HOST -> $ADDR"
      else
        echo -e "fail\t$A -> $HOST -> [unassigned]"
      fi
    fi
  done
done

echo ""
echo "DONE."
