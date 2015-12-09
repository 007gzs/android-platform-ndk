/*
 * Copyright (c) 2011-2015 CrystaX.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are
 * permitted provided that the following conditions are met:
 *
 *    1. Redistributions of source code must retain the above copyright notice, this list of
 *       conditions and the following disclaimer.
 *
 *    2. Redistributions in binary form must reproduce the above copyright notice, this list
 *       of conditions and the following disclaimer in the documentation and/or other materials
 *       provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY CrystaX ''AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL CrystaX OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are those of the
 * authors and should not be interpreted as representing official policies, either expressed
 * or implied, of CrystaX.
 */

#include "fileio/api.hpp"
#include "system/driver.hpp"

namespace crystax
{
namespace fileio
{

CRYSTAX_LOCAL
int pipe(int pipefd[2])
{
    TRACE;

    int fds[2];
    int ret = system_pipe(fds);
    if (ret < 0)
        return -1;

    pipefd[0] = alloc_fd(NULL, fds[0], system::driver_t::instance());
    if (pipefd[0] == -1)
    {
        system_close(fds[0]);
        system_close(fds[1]);
        errno = EMFILE;
        return -1;
    }
    pipefd[1] = alloc_fd(NULL, fds[1], system::driver_t::instance());
    if (pipefd[1] == -1)
    {
        free_fd(pipefd[0]);
        system_close(fds[0]);
        system_close(fds[1]);
        errno = EMFILE;
        return -1;
    }

    return 0;
}

} // namespace fileio
} // namespace crystax

CRYSTAX_GLOBAL
int pipe(int pipefd[2])
{
    return ::crystax::fileio::pipe(pipefd);
}
