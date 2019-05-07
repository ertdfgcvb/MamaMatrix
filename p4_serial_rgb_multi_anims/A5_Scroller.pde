class A5_Scroller extends Anim {

  PFont f;
  String[] scroller_text;  

  float speed      = 1;
  float pos_offset = 0;
  int text_offset  = 0;

  public A5_Scroller() {
    f = loadFont("akz.vlw");
    scroller_text = loadStrings("scroller_text.txt");
  }

  void render(PGraphics target, int t) {

    color col_fg = color(255, 0, 0); // foreground color
    color col_bg = color(0, 0, 0);   // background color

    target.beginDraw();
    target.translate(-pos_offset, 0);
    target.background(col_bg);
    target.textFont(f);
    target.textAlign(LEFT, TOP);

    float space_width = target.textWidth(" ");
    float x = 0;

    for (int i=0; i<5; i++) {
      String txt = scroller_text[(text_offset + i) % scroller_text.length];
      float w1 = target.textWidth(txt);

      if ((i + text_offset) % 2 == 0) {
        target.fill(col_fg);
      } else {
        target.noStroke();
        target.fill(col_fg);
        target.rect(x -space_width/2, 0, w1 + space_width, MATRIX_HEIGHT);
        target.fill(col_bg);
      }
      target.text(txt, x, 0);
      x += w1 + space_width;
    }

    target.endDraw();

    pos_offset += speed;
    float tw1 = target.textWidth(scroller_text[text_offset] + " ");
    if (pos_offset >= tw1) {
      pos_offset -= tw1;
      text_offset = (text_offset + 1) % scroller_text.length;
    }
  }
}
