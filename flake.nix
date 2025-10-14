{
  outputs =
    { ... }:
    {
      templates = {
        rust = {
          path = ./rust;
          description = "rust template";
        };
        bevy = {
          path = ./bevy;
          description = "rust + bevy template";
        };
        typst = {
          path = ./typst;
          description = "typst template";
        };
      };
    };
}
