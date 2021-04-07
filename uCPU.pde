Serial microPC;

char[] toBase64(byte[] bb) {
  char charArr[] = new char[11]; 
  char temp = ':';
  for(int i = 0; i < 11; i++) {
    temp = ':';
    if(bb[((6*i)+0)%64] != ' ') temp += 32;
    if(bb[((6*i)+1)%64] != ' ') temp += 16;
    if(bb[((6*i)+2)%64] != ' ') temp += 8;
    if(bb[((6*i)+3)%64] != ' ') temp += 4;
    if(bb[((6*i)+4)%64] != ' ') temp += 2;
    if(bb[((6*i)+5)%64] != ' ') temp += 1;

  charArr[i] = temp;
  }
  
  return charArr;
}
