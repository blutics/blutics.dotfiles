-- python-lsp-server는 Mason으로 설치가 가능했지만
--    pylsp-rope와 rope는 설치가 안되었다
--    이건 코드를 통해서 python-lsp-server가 설치되어 있으면 이 둘을 설치되도록
--    Mason코드에 넣어 놓았다. 추후 문제가 발생하면 해당 플러그인 참조
-- rope을 통한 auto-import는 한번 사용한 패키지만 auto complete 리스트에 auto-import 대상으로 뜬다
return {
  settings = {
    pylsp = {
      plugins = {
        rope_autoimport = {
          enabled = true,
          -- Pyright 완성으로 통일하고 싶다면, rope 쪽 완성은 끄고
          completions = { enabled = false },
          code_actions = { enabled = true },
        },
        jedi_completion = { enabled = false }, -- 중복 완성 방지
        rope_completion = { enabled = false }, -- 중복 완성 방지
        -- (원한다면 linter류도 모두 false로 깔끔히 비활성)
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        mccabe = { enabled = false },
      },
    },
  },
}
