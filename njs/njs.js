function hello(r) {
  r.return(200, 'Hello world!\n')
}

function apiAddr(r) {
  const header = 'version'
  const headerValue = r.headersIn[header]

  if (headerValue === 'new') {
    r.log(`exist________${header}: ${headerValue}`)

    return 'http://127.0.0.1/new_api'
  }
  
  return 'http://127.0.0.1/old_api'
}

export default { hello, apiAddr }