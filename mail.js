async function sendMail(data) {
    // 发送询价邮件到自建邮件服务器
    return await fetch('https://email-server-naxiwell.vercel.app/api/send-email.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
}
